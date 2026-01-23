<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

// 配置项：数据源地址
// 请确保你的 web 服务器（Nginx/Caddy）将 stats.json 暴露在可以通过浏览器访问的 URL
// 如果 stats.json 和文档站在同域下，可以使用相对路径，例如 '/json/stats.json'
const DATA_URL = '../../../ServerStatus/web/json/stats.json' 
const REFRESH_INTERVAL = 2000 // 刷新间隔（毫秒）

const servers = ref([])
const loading = ref(true)
const error = ref(null)
const lastUpdated = ref('')
let timer = null

// 工具函数：格式化流量/大小
const formatBytes = (bytes) => {
  if (bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
}

// 工具函数：格式化运行时间
const formatUptime = (seconds) => {
  const days = Math.floor(seconds / 86400)
  const hours = Math.floor((seconds % 86400) / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  return `${days}天 ${hours}小时 ${minutes}分`
}

// 工具函数：计算百分比颜色
const getProgressColor = (percent) => {
  if (percent > 90) return '#ef4444' // Red
  if (percent > 70) return '#eab308' // Yellow
  return '#3b82f6' // Blue
}

const fetchData = async () => {
  try {
    const res = await fetch(DATA_URL)
    if (!res.ok) throw new Error('Network response was not ok')
    const data = await res.json()
    servers.value = data.servers || []
    lastUpdated.value = new Date().toLocaleTimeString()
    loading.value = false
    error.value = null
  } catch (err) {
    error.value = '无法连接到探针数据源，请检查网络或配置。'
    console.error(err)
  }
}

onMounted(() => {
  fetchData()
  timer = setInterval(fetchData, REFRESH_INTERVAL)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
})
</script>

<template>
  <div class="status-container">
    <div class="status-header">
      <div class="header-title">
        <h2>🔥 节点监控</h2>
        <span v-if="loading" class="tag loading">连接中...</span>
        <span v-else-if="error" class="tag offline">异常</span>
        <span v-else class="tag online">运行正常 · {{ servers.length }} 个节点</span>
      </div>
      <div class="last-updated" v-if="!loading">
        更新于: {{ lastUpdated }}
      </div>
    </div>

    <div v-if="error" class="error-banner">
      {{ error }} <br>
      <small>请确认 <code>stats.json</code> 路径配置正确且允许跨域(CORS)。</small>
    </div>

    <div class="server-grid" v-if="!loading && !error">
      <div 
        v-for="server in servers" 
        :key="server.name" 
        class="server-card"
        :class="{ 'offline-card': !server.online4 && !server.online6 }"
      >
        <div class="card-header">
          <div class="server-info">
            <div class="flag-icon">{{ server.location.includes('HK') ? '🇭🇰' : server.location.includes('US') ? '🇺🇸' : server.location.includes('JP') ? '🇯🇵' : '🏳️' }}</div>
            <div class="server-name">
              <h3>{{ server.name }}</h3>
              <span class="server-type">{{ server.type }}</span>
            </div>
          </div>
          <div class="status-indicator">
            <span class="dot" :class="{ online: server.online4 || server.online6 }"></span>
            <span class="status-text">{{ (server.online4 || server.online6) ? 'Online' : 'Offline' }}</span>
          </div>
        </div>

        <div v-if="server.online4 || server.online6" class="card-body">
          
          <div class="progress-group">
            <div class="progress-item">
              <div class="progress-label">
                <span>CPU</span>
                <span>{{ server.cpu }}%</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: server.cpu + '%', background: getProgressColor(server.cpu) }"></div>
              </div>
            </div>
            
            <div class="progress-item">
              <div class="progress-label">
                <span>内存</span>
                <span>{{ Math.round((server.memUsed / server.memTotal) * 100) }}%</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: (server.memUsed / server.memTotal) * 100 + '%', background: getProgressColor((server.memUsed / server.memTotal) * 100) }"></div>
              </div>
              <div class="progress-subtext">{{ formatBytes(server.memUsed * 1024) }} / {{ formatBytes(server.memTotal * 1024) }}</div>
            </div>

            <div class="progress-item">
              <div class="progress-label">
                <span>硬盘</span>
                <span>{{ Math.round((server.hddUsed / server.hddTotal) * 100) }}%</span>
              </div>
              <div class="progress-track">
                <div class="progress-fill" :style="{ width: (server.hddUsed / server.hddTotal) * 100 + '%', background: '#8b5cf6' }"></div>
              </div>
              <div class="progress-subtext">{{ formatBytes(server.hddUsed * 1024 * 1024) }} / {{ formatBytes(server.hddTotal * 1024 * 1024) }}</div>
            </div>
          </div>

          <div class="stats-grid">
            <div class="stat-box">
              <span class="stat-label">上传速度</span>
              <span class="stat-value">↑ {{ formatBytes(server.networkTx) }}/s</span>
            </div>
            <div class="stat-box">
              <span class="stat-label">下载速度</span>
              <span class="stat-value">↓ {{ formatBytes(server.networkRx) }}/s</span>
            </div>
            <div class="stat-box">
              <span class="stat-label">总流量出</span>
              <span class="stat-value">{{ formatBytes(server.networkOUT) }}</span>
            </div>
            <div class="stat-box">
              <span class="stat-label">总流量入</span>
              <span class="stat-value">{{ formatBytes(server.networkIN) }}</span>
            </div>
          </div>

          <div class="card-footer">
            <div class="uptime">⏱ {{ formatUptime(server.uptime) }}</div>
            <div class="load" title="Load Average">Load: {{ server.load ? server.load : 'N/A' }}</div>
          </div>

        </div>

        <div v-else class="offline-body">
          <div class="offline-icon">💤</div>
          <p>服务器已离线</p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 容器 */
.status-container {
  padding: 20px 0;
  max-width: 1200px;
  margin: 0 auto;
}

/* 头部 */
.status-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-title h2 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  border: none;
}

.tag {
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 0.75rem;
  font-weight: 600;
}
.tag.loading { background: var(--vp-c-bg-soft); color: var(--vp-c-text-2); }
.tag.online { background: rgba(16, 185, 129, 0.1); color: #10b981; }
.tag.offline { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

.last-updated {
  font-size: 0.875rem;
  color: var(--vp-c-text-3);
}

/* 错误提示 */
.error-banner {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.2);
  color: #ef4444;
  padding: 16px;
  border-radius: 8px;
  margin-bottom: 20px;
  text-align: center;
}

/* 网格布局 */
.server-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

/* 卡片样式 */
.server-card {
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  border-radius: 12px;
  padding: 16px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0,0,0,0.02);
}

.server-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 20px rgba(0,0,0,0.05);
  border-color: var(--vp-c-brand);
}

.offline-card {
  opacity: 0.7;
  filter: grayscale(0.8);
}

/* 卡片头部 */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--vp-c-divider);
}

.server-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.flag-icon {
  font-size: 1.5rem;
}

.server-name h3 {
  margin: 0;
  font-size: 1rem;
  font-weight: 600;
  line-height: 1.2;
}

.server-type {
  font-size: 0.75rem;
  color: var(--vp-c-text-3);
  text-transform: uppercase;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 0.75rem;
  font-weight: 500;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #ef4444;
  box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.2);
}

.dot.online {
  background: #10b981;
  box-shadow: 0 0 0 2px rgba(16, 185, 129, 0.2);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0.4); }
  70% { box-shadow: 0 0 0 4px rgba(16, 185, 129, 0); }
  100% { box-shadow: 0 0 0 0 rgba(16, 185, 129, 0); }
}

/* 进度条 */
.progress-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 16px;
}

.progress-item {
  width: 100%;
}

.progress-label {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  margin-bottom: 4px;
  color: var(--vp-c-text-2);
}

.progress-track {
  width: 100%;
  height: 6px;
  background: var(--vp-c-bg-mute);
  border-radius: 3px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 0.5s ease;
}

.progress-subtext {
  font-size: 0.7rem;
  color: var(--vp-c-text-3);
  text-align: right;
  margin-top: 2px;
}

/* 网络统计 */
.stats-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
  background: var(--vp-c-bg-mute);
  padding: 10px;
  border-radius: 8px;
  margin-bottom: 12px;
}

.stat-box {
  display: flex;
  flex-direction: column;
}

.stat-label {
  font-size: 0.7rem;
  color: var(--vp-c-text-3);
}

.stat-value {
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
}

/* 底部 */
.card-footer {
  display: flex;
  justify-content: space-between;
  font-size: 0.75rem;
  color: var(--vp-c-text-3);
  padding-top: 8px;
  border-top: 1px dashed var(--vp-c-divider);
}

/* 离线状态 */
.offline-body {
  text-align: center;
  padding: 40px 0;
  color: var(--vp-c-text-3);
}
.offline-icon {
  font-size: 2rem;
  margin-bottom: 8px;
}
</style>
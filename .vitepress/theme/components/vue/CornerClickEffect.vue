<script setup>
// 鼠标点击粒子特效组件
import { ref, onMounted, onUnmounted } from 'vue'

const particles = ref([])
let idCounter = 0

const handleClick = (e) => {
  const x = e.clientX
  const y = e.clientY
  const clickId = ++idCounter
  const particleCount = 8 // 粒子数量

  // 创建多个粒子
  for (let i = 0; i < particleCount; i++) {
    const angle = (Math.PI * 2 * i) / particleCount + Math.random() * 0.5
    const speed = 50 + Math.random() * 50
    const size = 3 + Math.random() * 4
    const hue = Math.random() * 60 + 150 // 蓝绿色系

    particles.value.push({
      id: `${clickId}-${i}`,
      x,
      y,
      vx: Math.cos(angle) * speed,
      vy: Math.sin(angle) * speed,
      size,
      hue,
      life: 1
    })
  }

  // 1秒后清理
  setTimeout(() => {
    particles.value = particles.value.filter(p => !p.id.startsWith(clickId))
  }, 1000)
}

// 动画循环
let animationFrame
const animate = () => {
  particles.value = particles.value
    .map(p => ({
      ...p,
      x: p.x + p.vx * 0.016,
      y: p.y + p.vy * 0.016,
      vy: p.vy + 0.5, // 重力
      life: p.life - 0.02
    }))
    .filter(p => p.life > 0)

  animationFrame = requestAnimationFrame(animate)
}

onMounted(() => {
  document.addEventListener('click', handleClick)
  animationFrame = requestAnimationFrame(animate)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClick)
  if (animationFrame) cancelAnimationFrame(animationFrame)
})
</script>

<template>
  <div class="particle-effects">
    <div
      v-for="p in particles"
      :key="p.id"
      class="particle"
      :style="{
        left: p.x + 'px',
        top: p.y + 'px',
        width: p.size + 'px',
        height: p.size + 'px',
        opacity: p.life,
        background: `hsl(${p.hue}, 80%, 60%)`,
        boxShadow: `0 0 ${p.size * 2}px hsl(${p.hue}, 80%, 60%)`
      }"
    ></div>
  </div>
</template>

<style scoped>
.particle-effects {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 99999;
  overflow: hidden;
}

.particle {
  position: absolute;
  border-radius: 50%;
  transform: translate(-50%, -50%);
}
</style>

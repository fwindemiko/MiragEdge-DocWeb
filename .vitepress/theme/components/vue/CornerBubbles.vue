<script setup>
// 漂浮泡泡组件
import { ref, onMounted } from 'vue'

const bubbles = ref([])

onMounted(() => {
  // 生成泡泡
  for (let i = 0; i < 15; i++) {
    bubbles.value.push({
      id: i,
      left: Math.random() * 100,
      size: 8 + Math.random() * 20,
      delay: Math.random() * 10,
      duration: 12 + Math.random() * 8,
      hue: Math.random() * 60 + 170 // 蓝色到紫色范围
    })
  }
})
</script>

<template>
  <div class="bubbles-container">
    <div
      v-for="bubble in bubbles"
      :key="bubble.id"
      class="bubble"
      :style="{
        left: bubble.left + '%',
        width: bubble.size + 'px',
        height: bubble.size + 'px',
        animationDelay: bubble.delay + 's',
        animationDuration: bubble.duration + 's',
        background: `linear-gradient(135deg, hsla(${bubble.hue}, 70%, 70%, 0.3), hsla(${bubble.hue + 20}, 60%, 80%, 0.1))`
      }"
    ></div>
  </div>
</template>

<style scoped>
.bubbles-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 9996;
  overflow: hidden;
}

.bubble {
  position: absolute;
  bottom: -50px;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(1px);
  animation: rise linear infinite;
}

@keyframes rise {
  0% {
    transform: translateY(0) scale(1);
    opacity: 0;
  }
  10% {
    opacity: 0.6;
  }
  90% {
    opacity: 0.6;
  }
  100% {
    transform: translateY(-110vh) scale(0.8);
    opacity: 0;
  }
}
</style>

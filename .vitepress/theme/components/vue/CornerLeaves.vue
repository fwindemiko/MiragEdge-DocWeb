<script setup>
// 漂浮叶子组件
import { ref, onMounted } from 'vue'

const leaves = ref([])

onMounted(() => {
  // 生成叶子
  for (let i = 0; i < 15; i++) {
    leaves.value.push({
      id: i,
      left: Math.random() * 100,
      delay: Math.random() * 8,
      duration: 10 + Math.random() * 8,
      size: 12 + Math.random() * 12,
      hue: Math.floor(Math.random() * 50) // 绿色到黄色
    })
  }
})
</script>

<template>
  <div class="leaves-container">
    <div
      v-for="leaf in leaves"
      :key="leaf.id"
      class="leaf"
      :style="{
        left: leaf.left + '%',
        animationDelay: leaf.delay + 's',
        animationDuration: leaf.duration + 's',
        width: leaf.size + 'px',
        height: leaf.size + 'px',
        background: `linear-gradient(135deg,
          hsl(${leaf.hue + 80}, 70%, 45%) 0%,
          hsl(${leaf.hue + 90}, 60%, 35%) 100%)`
      }"
    ></div>
  </div>
</template>

<style scoped>
.leaves-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 9996;
  overflow: hidden;
}

.leaf {
  position: absolute;
  top: -30px;
  border-radius: 0 80% 0 80%;
  animation: fall-leaf linear infinite;
}

@keyframes fall-leaf {
  0% {
    transform: translateY(-30px) rotate(0deg) translateX(0);
    opacity: 0;
  }
  10% {
    opacity: 0.8;
  }
  90% {
    opacity: 0.8;
  }
  100% {
    transform: translateY(110vh) rotate(360deg) translateX(30px);
    opacity: 0;
  }
}
</style>

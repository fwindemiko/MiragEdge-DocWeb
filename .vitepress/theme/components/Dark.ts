import { nextTick, provide, readonly, ref } from 'vue'

// 全局暗色模式状态
const isDarkState = ref(false)

// 判断是否能使用 startViewTransition
const enableTransitions = () => {
  return 'startViewTransition' in document && window.matchMedia('(prefers-reduced-motion: no-preference)').matches
}

// 暴露一个响应式的暗色模式状态供外部读取
export const useDarkMode = () => {
  return {
    isDark: readonly(isDarkState),
  }
}

// 提供切换暗色模式的函数（通过 provide 机制）
export const toggleDark = (isDarkRef) => {
  // 创建一个可写的响应式，每次切换时更新
  const toggle = async (e?: MouseEvent) => {
    const isDark = isDarkRef.value
    
    if (!enableTransitions()) {
      isDarkRef.value = !isDark
      return
    }
    
    if (e) {
      document.documentElement.style.setProperty('--darkX', e.clientX + 'px')
      document.documentElement.style.setProperty('--darkY', e.clientY + 'px')
    }
    
    await document.startViewTransition(async () => {
      isDarkRef.value = !isDark
      await nextTick()
    }).ready
  }
  
  provide('toggle-appearance', toggle)
  
  return toggle
}

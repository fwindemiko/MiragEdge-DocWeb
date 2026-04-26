---
# https://vitepress.dev/reference/default-theme-home-page
layout: home
title: MiragEdge 文档中心

hero:
  name: "锐界幻境"
  text: "Minecraft 生存服务器"
  tagline: 👼🏻 远离困扰之地（锐界）和天堂般的境地（幻境），在数字荒漠中打造一片绿洲，让每个玩家都能找到属于自己的幻境
  image:
    src: /resourcepack/items_skin/food/sweet_berries_cupcake.png
    alt: MiragEdge
  actions:
    - theme: brand
      text: 玩家指南
      link: /manual/review.md
    - theme: alt
      text: 玩法介绍
      link: /features

features:
  - icon: 🚢
    title: 创新玩法
    details: 独家轻 RPG 系统、星露谷、附魔等多维度玩法
  - icon: 💾
    title: 高性能优化
    details: 高性能设备，先进架构优化，多线路负载均衡
  - icon: ❤️
    title: 优秀社区
    details: 公益化纯净体验，7×24 小时管理在线，跨次元社交生态
  - icon: 🔧
    title: 稳定保障
    details: 长期开服不换档，每日增量备份 + 异地容灾，强力反作弊，自动白名单
  - icon: 🔄
    title: 持续更新
    details: 长期更新优化，不断添加趣味功能与修复问题
---

## 🚀 服务器概况

**锐界幻境** 是一个致力于打造开放创新 Minecraft 游戏平台的公益服务器。我们相信每个玩家都值得拥有一个自由、纯净、有趣的游戏环境。

### 核心理念

- 🎮 **高品质体验** - 精心配置，只为更好的游戏感受
- 🤝 **社区驱动** - 玩家声音是我们进步的动力
- 🔒 **安全稳定** - 专业运维，数据安全有保障
- 💡 **持续创新** - 不断探索新的玩法和可能性

## 💻 硬件配置

服务器采用高性能硬件配置，确保游戏流畅运行：

- **处理器** - 英特尔 i5 14600KF（5.6GHz 超频）
- **内存** - 64GB 高频内存
- **网络** - 宁波电信百兆 + 宿迁三线 BGP 优化百兆
- **存储** - 三星数据中心级 SSD

## 🛡️ 软件架构与备份策略

### 服务架构

使用 **Velocity** 反向代理 + **Purpur** 服务端，全容器化管理，JumpServer 堡垒机安全协作，专业的网络优化，确保低延迟高稳定。

### 数据备份

- **数据库备份** — 每日 4 次，实时保护游戏数据
- **虚拟机克隆** — 每周，完整系统快照
- **云端归档** — 每月，异地容灾保障

> 梦始之空世界存档 **永久保存**，我们承诺不会删除任何玩家的心血结晶。

## 📢 获取帮助

- 💬 **玩家交流群**: 523914625
- 🐛 **问题反馈**: [GitHub Issues](https://github.com/fwindemiko/MiragEdge-DocWeb/issues)
- 💻 **贡献代码**: [GitHub 仓库](https://github.com/fwindemiko/MiragEdge-DocWeb)

## 📝 开发者的话

> 语言学科是我的弱项，若文档有写得不好的地方，恳请指正 🙏
>
> 除了运营锐界幻境外，我们还提供下面服务：
> - 开服技术咨询
> - 有偿问题解决
> - 中小插件定制开发
>
> 对锐界幻境的最终目标是：**"实现一个开放创新的服务器平台"**
>
> —— 狐风轩汐 (F.windEmiko)

<style scoped>
#star-canvas {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 0;
}

.VPHome {
  position: relative;
  z-index: 1;
}
</style>

<canvas id="star-canvas"></canvas>

<script setup>
import { onMounted, onUnmounted, nextTick } from 'vue'

// 封面图片列表
const images = [
  '/title_img/icon-1.png',
  '/title_img/icon-2.png',
  '/title_img/icon-3.png',
]

// 隐藏款图片
const hiddenImage = '/title_img/icon-dis.png'

let animationFrameId = null
let particles = []

onMounted(async () => {
  await nextTick()

  // 加权随机选择：dis.png 概率为其他图片的 1/5
  const weightedImages = [
    ...images.flatMap(img => Array(5).fill(img)),
    hiddenImage
  ]

  const randomImage = weightedImages[Math.floor(Math.random() * weightedImages.length)]

  // 查找 hero 图片元素
  const selectors = [
    '.VPHomeHero .VPImage img',
    '.VPHomeHero img',
    'main .VPImage img',
    '[alt="xingjiu"]'
  ]

  let heroImage = null
  for (const selector of selectors) {
    heroImage = document.querySelector(selector)
    if (heroImage) break
  }

  const setImage = (imgElement, imageSrc) => {
    imgElement.src = imageSrc
    imgElement.alt = 'xingjiu'
    // emoji4.png 需要放大
    if (imageSrc.includes('emoji4.png')) {
      imgElement.style.transform = 'scale(1.5)'
      imgElement.style.transformOrigin = 'center'
    } else {
      imgElement.style.transform = ''
      imgElement.style.transformOrigin = ''
    }
  }

  if (heroImage) {
    setImage(heroImage, randomImage)
  } else {
    setTimeout(() => {
      for (const selector of selectors) {
        heroImage = document.querySelector(selector)
        if (heroImage) {
          setImage(heroImage, randomImage)
          break
        }
      }
    }, 100)
  }

  initStarEffect()
})

onUnmounted(() => {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId)
  }
})

function initStarEffect() {
  const canvas = document.getElementById('star-canvas')
  if (!canvas) return

  const ctx = canvas.getContext('2d')
  let width = canvas.width = window.innerWidth
  let height = canvas.height = window.innerHeight

  const config = {
    spawnRate: 12,
    startSpeed: 0.6,
    attraction: 0.015,
    mouseForce: 0.05,
    maxMouseForce: 1.5,
    maxStarSpeed: 3.0,
    friction: 0.98,
    minDriftSpeed: 0.3,
    starBaseSize: 4,
    circleRadius: 600
  }

  const mouse = {
    x: undefined,
    y: undefined,
    vx: 0,
    vy: 0,
    lastX: 0,
    lastY: 0,
    isMoving: false,
    timer: null
  }

  const resize = () => {
    width = canvas.width = window.innerWidth
    height = canvas.height = window.innerHeight
  }

  window.addEventListener('resize', resize)

  window.addEventListener('mousemove', (e) => {
    mouse.x = e.x
    mouse.y = e.y
    mouse.vx = e.x - mouse.lastX
    mouse.vy = e.y - mouse.lastY
    mouse.lastX = e.x
    mouse.lastY = e.y
    mouse.isMoving = true

    clearTimeout(mouse.timer)
    mouse.timer = setTimeout(() => {
      mouse.vx = 0
      mouse.vy = 0
      mouse.isMoving = false
      mouse.x = undefined
      mouse.y = undefined
    }, 100)
  })

  class Star {
    constructor(centerX, centerY) {
      const angle = Math.random() * Math.PI * 2
      const radius = Math.random() * config.circleRadius * 0.3 + config.circleRadius * 0.1
      this.x = centerX + Math.cos(angle) * radius
      this.y = centerY + Math.sin(angle) * radius

      const driftAngle = angle + (Math.random() - 0.5) * 0.5
      const speed = config.startSpeed + Math.random() * 0.3

      this.vx = Math.cos(driftAngle) * speed
      this.vy = Math.sin(driftAngle) * speed

      this.size = Math.random() * 5 + config.starBaseSize
      this.life = 1
      this.decay = Math.random() * 0.001 + 0.0015
      this.hue = Math.random() * 60 + 180
    }

    draw(ctx) {
      ctx.save()
      ctx.translate(this.x, this.y)
      ctx.rotate(this.life * 0.5)

      ctx.beginPath()
      const r = this.size
      ctx.moveTo(0, -r)
      ctx.quadraticCurveTo(0, 0, r, 0)
      ctx.quadraticCurveTo(0, 0, 0, r)
      ctx.quadraticCurveTo(0, 0, -r, 0)
      ctx.quadraticCurveTo(0, 0, 0, -r)
      ctx.closePath()

      const gradient = ctx.createRadialGradient(0, 0, 0, 0, 0, r)
      gradient.addColorStop(0, `hsla(${this.hue}, 80%, 80%, ${this.life})`)
      gradient.addColorStop(1, `hsla(${this.hue}, 80%, 50%, ${this.life})`)

      ctx.fillStyle = gradient
      ctx.fill()
      ctx.restore()
    }

    update() {
      if (mouse.x !== undefined) {
        const dx = mouse.x - this.x
        const dy = mouse.y - this.y
        const distance = Math.sqrt(dx * dx + dy * dy)

        if (distance < 300) {
          const forceX = dx / distance
          const forceY = dy / distance

          this.vx += forceX * config.attraction
          this.vy += forceY * config.attraction

          if (mouse.isMoving) {
            let pushX = mouse.vx * config.mouseForce
            let pushY = mouse.vy * config.mouseForce

            const pushStrength = Math.sqrt(pushX * pushX + pushY * pushY)
            if (pushStrength > config.maxMouseForce) {
              const scale = config.maxMouseForce / pushStrength
              pushX *= scale
              pushY *= scale
            }

            this.vx += pushX
            this.vy += pushY
          }
        }
      }

      this.vx *= config.friction
      this.vy *= config.friction

      const currentSpeed = Math.sqrt(this.vx * this.vx + this.vy * this.vy)
      if (currentSpeed > config.maxStarSpeed) {
        const scale = config.maxStarSpeed / currentSpeed
        this.vx *= scale
        this.vy *= scale
      }

      if (currentSpeed < config.minDriftSpeed) {
        const heroImage = document.querySelector('.VPHomeHero .VPImage img') ||
                         document.querySelector('.VPHomeHero img')
        if (heroImage) {
          const rect = heroImage.getBoundingClientRect()
          const centerX = rect.left + rect.width / 2
          const centerY = rect.top + rect.height / 2
          const angleToCenter = Math.atan2(this.y - centerY, this.x - centerX)
          this.vx += Math.cos(angleToCenter) * 0.005
          this.vy += Math.sin(angleToCenter) * 0.005
        }
      }

      this.x += this.vx
      this.y += this.vy
      this.hue += 0.2
      this.life -= this.decay
    }
  }

  let frame = 0

  const animate = () => {
    animationFrameId = requestAnimationFrame(animate)

    ctx.clearRect(0, 0, width, height)
    ctx.globalCompositeOperation = 'lighter'

    frame++

    const heroImage = document.querySelector('.VPHomeHero .VPImage img') ||
                     document.querySelector('.VPHomeHero img')

    if (heroImage && frame % config.spawnRate === 0) {
      const rect = heroImage.getBoundingClientRect()
      const centerX = rect.left + rect.width / 2
      const centerY = rect.top + rect.height / 2
      particles.push(new Star(centerX, centerY))
    }

    for (let i = particles.length - 1; i >= 0; i--) {
      const p = particles[i]
      p.update()
      p.draw(ctx)

      if (p.life <= 0) {
        particles.splice(i, 1)
      }
    }

    ctx.globalCompositeOperation = 'source-over'
  }

  animate()
}
</script>

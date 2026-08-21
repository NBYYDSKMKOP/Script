import { createFileRoute } from '@tanstack/react-router'
import { useRef, useState, type ChangeEvent, type ReactNode } from 'react'
import { Check, ChevronDown, Download, Globe2, ImagePlus, MessageCircle, ShieldCheck, Sparkles, Users } from 'lucide-react'

const servers = [
  'ohio', '枪地FFA', '忍者传奇', 'TSB', '8个球池经典', '鲨鱼咬伤2', '挖穿地球', '进击的巨人', 'BF', '门', '竞争对手',
  '恐鬼症', '启示录', '去钓鱼', '闪光', '死铁轨', '一路向西', '健身联盟', '躲避', '犯罪', '项目三角洲', '声名狼藉',
  '被遗弃', '无敌少侠', 'GB', '亡命速递', 'MVSD', 'MM2', 'AUT', '死亡之死', '正在寻求', '锻造', '无家可归模拟器',
  '跳跃对决', '墨水游戏', '链条', '决斗场', '兵工厂', '死亡球', '英雄战场', '像素之刃', '监狱人生', '根深蒂固',
  '驾驶帝国', '反布洛克斯', '战争大亨', '压力', '布洛克斯·斯特莱克', '盲射', '武器库', '暴力区', '动感星期五', 'STBB',
  '元素大亨', '力量传奇', '炼油厂洞穴2', '战争机器', '割草机', 'CDI', '夜光', '午夜追逐者', '入侵者', '点击模拟器',
  '终极战场', '3008', 'JJS', '战斗勇士', '99夜生存', '血债', '生存与杀手', '排水城', '血腥纳克鲁斯', '超速射击',
  '丹迪的世界', '越狱', '无标题的近战RNG', '恩典', '水手碎片', '割下草来获取脑袋', '街头生活', '达胡德', '闯入2',
  '古怪严格的爸爸', '沉默刺客', '猜猜我的号码', '撕咬之夜', '在启示录中生存', '平滑切片', '戒网瘾中心', '在启示录中生存',
  '英雄传奇', '监狱泵', '战斗入门', '在学校里战斗', '烤或死', '锋利', '手枪竞技场', '战斗竞技场', '狙击竞技场',
  '无限柔术', '恐龙生活', '踢幸运方块',
]

const qqLink = 'http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=P5VZMhGKrwX1Y3boXQCKtC60cpDRgvYM&authKey=7QHNiAIpvjkLiCpxqzhk20pJxk3ImiWkfSRPsErsCBH%2BjNzqFlEWkkW4zvdV%2FLuO&noverify=0&group_code=1097504005'
const qqAppLink = 'mqqapi://card/show_pslcard?src_type=internal&version=1&uin=1097504005&card_type=group&source=qrcode'

function openQQGroup(event: React.MouseEvent<HTMLAnchorElement>) {
  event.preventDefault()
  window.location.href = qqAppLink
  window.setTimeout(() => {
    window.location.href = qqLink
  }, 900)
}

function GlassCard({ title, children, className = '' }: { title: string; children: ReactNode; className?: string }) {
  return <section className={`glass-card ${className}`}><div className="card-heading"><span>{title}</span><i /></div>{children}</section>
}

export const Route = createFileRoute('/')({
  head: () => ({ meta: [
    { title: 'Atomic · 脚本介绍' },
    { name: 'description', content: 'Atomic 脚本介绍、售后保障与支持的服务器列表。' },
  ] }),
  component: Home,
})

function Home() {
  const [showServers, setShowServers] = useState(false)
  const [logoUrl, setLogoUrl] = useState<string | null>(null)
  const logoInputRef = useRef<HTMLInputElement>(null)

  const handleLogoChange = (event: ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0]
    if (file) setLogoUrl(URL.createObjectURL(file))
  }

  return <main className="atomic-page">
    <div className="atmosphere atmosphere-one" /><div className="atmosphere atmosphere-two" />
    <div className="page-shell">
      <header className="hero">
        <button className="logo-picker" type="button" onClick={() => logoInputRef.current?.click()} aria-label="上传自定义Logo">
          {logoUrl ? <img src={logoUrl} alt="自定义 Atomic Logo" /> : <span className="logo-fallback"><Sparkles size={23} /></span>}
          <span className="logo-edit"><ImagePlus size={12} /></span>
        </button>
        <input ref={logoInputRef} className="sr-only" type="file" accept="image/png,image/jpeg,image/webp,image/svg+xml" onChange={handleLogoChange} />
        <div className="eyebrow">ATOMIC SCRIPT · OFFICIAL</div>
        <h1>Atomic <em>- 脚本介绍 -</em></h1>
        <p>由神仇下专业团队制作 · 为每一位玩家提供更好的游玩环境</p>
        <div className="hero-status"><span className="status-dot" /> 服务在线 <span className="status-divider" /> 实时响应中</div>
      </header>

      <div className="intro-grid">
        <GlassCard title="关于我们" className="about-card">
          <p>Atomic-国内最顶级的脚本，我们拥有良好的服务态度。售后第一时间会回复所有用户的一切问题，会帮助用户拥有更好的游玩环境。</p>
          <p>由神仇下专业团队制作，持续更新稳定功能，专注于让每一次游玩都更加顺畅、安心。</p>
        </GlassCard>
        <GlassCard title="售后保障" className="support-card">
          <p>我们的项目已有 <strong>500+ 用户</strong>购买，良好的体验环境。有bug反馈与脚本问题，我们会第一时间修复并回复。</p>
          <p>平均用户对脚本满意有着 <strong>98% 以上</strong>的好评。我们有着很多强大的功能，碾压市面上一切野鸡脚本，独一无二的功能。</p>
        </GlassCard>
      </div>

      <GlassCard title="公告" className="notice-card">
        <div className="notice-copy"><span className="notice-mark">!</span><p>不要相信任何群里不是管理的人购买，否则被骗后果自负。认准管理购买。</p></div>
        <div className="price-row"><span>永久价格</span><b>50 <small>RMB</small></b></div>
      </GlassCard>

      <div className="actions">
        <button className={`action-button server-button ${showServers ? 'active' : ''}`} onClick={() => setShowServers(v => !v)} aria-expanded={showServers}>
          <span className="button-icon"><Globe2 size={17} /></span>{showServers ? '收起服务器' : '服务器列表'}<ChevronDown size={17} className={showServers ? 'rotate-180' : ''} />
        </button>
        <a className="action-button qq-button" href={qqLink} onClick={openQQGroup}><span className="button-icon"><MessageCircle size={17} /></span>加入QQ群</a>
        <a className="action-button download-button" href="/atomic-project-source.zip" download="atomic-project-source.zip"><span className="button-icon"><Download size={17} /></span>下载源码</a>
      </div>

      {showServers && <section className="server-panel" aria-label="支持的服务器列表">
        <div className="server-panel-head"><div><span className="panel-kicker">SUPPORTED SERVERS</span><h2>可用服务器</h2></div><div className="server-online"><span className="status-dot" /> 全部服务正常</div></div>
        <div className="server-summary"><span><Users size={14} /> 支持 <b>{servers.length}</b> 个服务器</span><span><Check size={14} /> 今日状态稳定</span></div>
        <div className="server-grid">{servers.map((server, index) => <button className="server-item" key={`${server}-${index}`}><span className="server-index">{String(index + 1).padStart(2, '0')}</span><span className="server-name">{server}</span><span className="server-live" /></button>)}</div>
      </section>}

      <div className="trust-line"><ShieldCheck size={15} /> 稳定更新 · 快速响应 · 专业售后</div>
      <footer>Atomic脚本 <span>—</span> 2026 本网站为介绍脚本而用 · 无不良引导</footer>
    </div>
  </main>
}

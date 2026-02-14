'use client'

import { useState } from 'react'
import { 
  Smartphone, 
  Cpu, 
  MessageSquare, 
  Users, 
  Download, 
  Github, 
  Star, 
  ArrowRight,
  Zap,
  Shield,
  Globe,
  GitFork,
  Heart,
  ChevronDown,
  Menu,
  X,
  Layers,
  Lightbulb,
  Settings,
  Wifi,
  Bot,
  Database,
  Code,
  CheckCircle,
  ExternalLink
} from 'lucide-react'

// Navigation Component
function Navbar() {
  const [isOpen, setIsOpen] = useState(false)
  
  return (
    <nav className="fixed top-0 left-0 right-0 z-50 glass-dark">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-xl flex items-center justify-center">
              <Cpu className="w-6 h-6 text-white" />
            </div>
            <span className="text-xl font-bold gradient-text">RepairAI</span>
          </div>
          
          {/* Desktop Menu */}
          <div className="hidden md:flex items-center space-x-8">
            <a href="#features" className="text-gray-300 hover:text-white transition-colors">Features</a>
            <a href="#how-it-works" className="text-gray-300 hover:text-white transition-colors">How It Works</a>
            <a href="#community" className="text-gray-300 hover:text-white transition-colors">Community</a>
            <a href="#download" className="text-gray-300 hover:text-white transition-colors">Download</a>
            <a 
              href="https://github.com/repairai/repairai" 
              target="_blank"
              className="flex items-center space-x-2 bg-gray-800 hover:bg-gray-700 px-4 py-2 rounded-lg transition-colors"
            >
              <Github className="w-5 h-5" />
              <span>GitHub</span>
            </a>
          </div>
          
          {/* Mobile Menu Button */}
          <div className="md:hidden">
            <button 
              onClick={() => setIsOpen(!isOpen)}
              className="p-2 rounded-lg hover:bg-gray-800 transition-colors"
            >
              {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>
      
      {/* Mobile Menu */}
      {isOpen && (
        <div className="md:hidden bg-gray-900 border-t border-gray-800">
          <div className="px-4 py-4 space-y-3">
            <a href="#features" className="block text-gray-300 hover:text-white">Features</a>
            <a href="#how-it-works" className="block text-gray-300 hover:text-white">How It Works</a>
            <a href="#community" className="block text-gray-300 hover:text-white">Community</a>
            <a href="#download" className="block text-gray-300 hover:text-white">Download</a>
          </div>
        </div>
      )}
    </nav>
  )
}

// Hero Section
function Hero() {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background Effects */}
      <div className="absolute inset-0 bg-dark-950">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,_var(--tw-gradient-stops))] from-blue-900/20 via-dark-950 to-dark-950" />
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl animate-pulse" />
        <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-cyan-500/10 rounded-full blur-3xl animate-pulse" style={{ animationDelay: '2s' }} />
      </div>
      
      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-32 pb-20">
        <div className="text-center">
          {/* Badge */}
          <div className="inline-flex items-center space-x-2 bg-blue-500/10 border border-blue-500/20 rounded-full px-4 py-2 mb-8">
            <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
            <span className="text-sm text-blue-400">Open Source & Free Forever</span>
          </div>
          
          {/* Title */}
          <h1 className="text-5xl md:text-7xl font-bold mb-6">
            <span className="gradient-text">AI-Powered</span>
            <br />
            Mobile Repair Assistant
          </h1>
          
          {/* Subtitle */}
          <p className="text-xl text-gray-400 max-w-2xl mx-auto mb-10">
            The first open-source repair assistant powered by AI. 
            Access schematics, solutions, and expert guidance - all in one place.
          </p>
          
          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-4">
            <a 
              href="#download"
              className="flex items-center space-x-2 bg-gradient-to-r from-blue-600 to-cyan-500 hover:from-blue-500 hover:to-cyan-400 px-8 py-4 rounded-xl font-semibold text-lg transition-all transform hover:scale-105"
            >
              <Download className="w-5 h-5" />
              <span>Download Free</span>
            </a>
            <a 
              href="https://github.com/repairai/repairai"
              target="_blank"
              className="flex items-center space-x-2 bg-gray-800 hover:bg-gray-700 px-8 py-4 rounded-xl font-semibold text-lg transition-colors"
            >
              <Github className="w-5 h-5" />
              <span>View on GitHub</span>
            </a>
          </div>
          
          {/* Stats */}
          <div className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-8 max-w-4xl mx-auto">
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">10K+</div>
              <div className="text-gray-500">Schematics</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">50K+</div>
              <div className="text-gray-500">Solutions</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">5K+</div>
              <div className="text-gray-500">Community Members</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold gradient-text">100+</div>
              <div className="text-gray-500">Device Models</div>
            </div>
          </div>
        </div>
        
        {/* Scroll indicator */}
        <div className="absolute bottom-10 left-1/2 transform -translate-x-1/2 animate-bounce">
          <ChevronDown className="w-8 h-8 text-gray-500" />
        </div>
      </div>
    </section>
  )
}

// Features Section
function Features() {
  const features = [
    {
      icon: Layers,
      title: 'Schematic Viewer',
      description: 'Access thousands of circuit diagrams for iPhone, Samsung, and more. Zoom, pan, and search through technical documentation.',
      gradient: 'from-blue-500 to-blue-600'
    },
    {
      icon: Lightbulb,
      title: 'AI Solutions',
      description: 'Get instant repair solutions powered by AI. Search through our database of 50,000+ verified fixes from expert technicians.',
      gradient: 'from-amber-500 to-orange-600'
    },
    {
      icon: MessageSquare,
      title: 'AI Chat Assistant',
      description: 'Chat with RepairAI about any repair issue. Our AI understands mobile hardware and provides step-by-step guidance.',
      gradient: 'from-green-500 to-emerald-600'
    },
    {
      icon: Database,
      title: 'Device Database',
      description: 'Comprehensive database of devices, parts, and specifications. Find compatible parts and pricing from trusted suppliers.',
      gradient: 'from-purple-500 to-violet-600'
    },
    {
      icon: Wifi,
      title: 'Offline Mode',
      description: 'Download schematics and solutions for offline access. Perfect for shops with limited internet connectivity.',
      gradient: 'from-cyan-500 to-teal-600'
    },
    {
      icon: Users,
      title: 'Community Driven',
      description: 'Built by repair technicians for repair technicians. Contribute solutions, schematics, and help improve the AI.',
      gradient: 'from-pink-500 to-rose-600'
    }
  ]
  
  return (
    <section id="features" className="py-24 bg-dark-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold mb-4">
            Everything You Need for <span className="gradient-text">Mobile Repair</span>
          </h2>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            A complete toolkit for professional repair technicians, powered by AI and the community.
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <div 
              key={index}
              className="group p-8 rounded-2xl bg-dark-800 border border-dark-700 hover:border-blue-500/50 transition-all hover:transform hover:-translate-y-1"
            >
              <div className={`w-14 h-14 rounded-xl bg-gradient-to-br ${feature.gradient} flex items-center justify-center mb-6 group-hover:scale-110 transition-transform`}>
                <feature.icon className="w-7 h-7 text-white" />
              </div>
              <h3 className="text-xl font-semibold mb-3">{feature.title}</h3>
              <p className="text-gray-400">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

// How It Works Section
function HowItWorks() {
  const steps = [
    {
      number: '01',
      title: 'Download & Install',
      description: 'Get RepairAI for Windows or Android completely free from our website or GitHub releases.',
      icon: Download
    },
    {
      number: '02',
      title: 'Configure AI',
      description: 'Add your Gemini or OpenRouter API key (or use the free tier) to unlock AI features.',
      icon: Settings
    },
    {
      number: '03',
      title: 'Search & Repair',
      description: 'Find schematics, solutions, or chat with our AI assistant for any repair problem.',
      icon: Bot
    },
    {
      number: '04',
      title: 'Contribute Back',
      description: 'Share your solutions with the community and help improve the AI for everyone.',
      icon: GitFork
    }
  ]
  
  return (
    <section id="how-it-works" className="py-24 bg-dark-950">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold mb-4">
            How <span className="gradient-text">RepairAI</span> Works
          </h2>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            Get started in minutes with our simple four-step process.
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {steps.map((step, index) => (
            <div key={index} className="relative">
              <div className="text-8xl font-bold text-dark-800 absolute -top-4 -left-2">
                {step.number}
              </div>
              <div className="relative z-10 pt-12">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-blue-600 to-cyan-500 flex items-center justify-center mb-6">
                  <step.icon className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-semibold mb-3">{step.title}</h3>
                <p className="text-gray-400">{step.description}</p>
              </div>
              {index < steps.length - 1 && (
                <ArrowRight className="hidden lg:block absolute -right-4 top-1/2 transform -translate-y-1/2 text-dark-700 w-8 h-8" />
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}

// Community Section
function Community() {
  return (
    <section id="community" className="py-24 bg-dark-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div>
            <h2 className="text-4xl font-bold mb-6">
              Built by the Community, <br />
              <span className="gradient-text">For the Community</span>
            </h2>
            <p className="text-xl text-gray-400 mb-8">
              RepairAI is open source and free forever. Our community of 5,000+ 
              repair technicians contributes schematics, solutions, and AI improvements 
              every day.
            </p>
            
            <div className="space-y-4">
              <div className="flex items-center space-x-4">
                <CheckCircle className="w-6 h-6 text-green-500" />
                <span className="text-gray-300">100% Free - No subscriptions, ever</span>
              </div>
              <div className="flex items-center space-x-4">
                <CheckCircle className="w-6 h-6 text-green-500" />
                <span className="text-gray-300">Open source under MIT license</span>
              </div>
              <div className="flex items-center space-x-4">
                <CheckCircle className="w-6 h-6 text-green-500" />
                <span className="text-gray-300">Community-driven AI training</span>
              </div>
              <div className="flex items-center space-x-4">
                <CheckCircle className="w-6 h-6 text-green-500" />
                <span className="text-gray-300">Your data stays on your device</span>
              </div>
            </div>
            
            <div className="mt-8 flex items-center space-x-4">
              <a 
                href="https://github.com/repairai/repairai"
                target="_blank"
                className="flex items-center space-x-2 bg-gray-800 hover:bg-gray-700 px-6 py-3 rounded-xl transition-colors"
              >
                <Github className="w-5 h-5" />
                <span>Star on GitHub</span>
              </a>
              <div className="flex items-center space-x-2 text-gray-400">
                <Heart className="w-5 h-5 text-red-500" />
                <span>Made with love</span>
              </div>
            </div>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div className="p-6 rounded-2xl bg-dark-800 border border-dark-700 text-center">
              <div className="text-3xl font-bold gradient-text mb-2">5K+</div>
              <div className="text-gray-400">Contributors</div>
            </div>
            <div className="p-6 rounded-2xl bg-dark-800 border border-dark-700 text-center">
              <div className="text-3xl font-bold gradient-text mb-2">1K+</div>
              <div className="text-gray-400">Pull Requests</div>
            </div>
            <div className="p-6 rounded-2xl bg-dark-800 border border-dark-700 text-center">
              <div className="text-3xl font-bold gradient-text mb-2">500+</div>
              <div className="text-gray-400">Issues Resolved</div>
            </div>
            <div className="p-6 rounded-2xl bg-dark-800 border border-dark-700 text-center">
              <div className="text-3xl font-bold gradient-text mb-2">50K+</div>
              <div className="text-gray-400">Downloads</div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

// Download Section
function Download() {
  return (
    <section id="download" className="py-24 bg-gradient-to-b from-dark-900 to-dark-950">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold mb-4">
            Download <span className="gradient-text">RepairAI</span> Now
          </h2>
          <p className="text-xl text-gray-400 max-w-2xl mx-auto">
            Available for Windows and Android. Completely free, forever.
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          {/* Windows Download */}
          <div className="p-8 rounded-2xl bg-dark-800 border border-dark-700 hover:border-blue-500/50 transition-all">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center space-x-4">
                <div className="w-16 h-16 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-2xl flex items-center justify-center">
                  <Smartphone className="w-8 h-8 text-white" />
                </div>
                <div className="text-left">
                  <h3 className="text-xl font-semibold">Windows</h3>
                  <p className="text-gray-400">Desktop Application</p>
                </div>
              </div>
            </div>
            <ul className="space-y-3 mb-6">
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>Full offline support</span>
              </li>
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>AI-powered features</span>
              </li>
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>Automatic updates</span>
              </li>
            </ul>
            <button className="w-full flex items-center justify-center space-x-2 bg-gradient-to-r from-blue-600 to-cyan-500 hover:from-blue-500 hover:to-cyan-400 px-6 py-3 rounded-xl font-semibold transition-all">
              <Download className="w-5 h-5" />
              <span>Download .EXE</span>
            </button>
          </div>
          
          {/* Android Download */}
          <div className="p-8 rounded-2xl bg-dark-800 border border-dark-700 hover:border-green-500/50 transition-all">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center space-x-4">
                <div className="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-400 rounded-2xl flex items-center justify-center">
                  <Smartphone className="w-8 h-8 text-white" />
                </div>
                <div className="text-left">
                  <h3 className="text-xl font-semibold">Android</h3>
                  <p className="text-gray-400">Mobile Application</p>
                </div>
              </div>
            </div>
            <ul className="space-y-3 mb-6">
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>APK + Play Store</span>
              </li>
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>AI-powered features</span>
              </li>
              <li className="flex items-center space-x-2 text-gray-300">
                <CheckCircle className="w-4 h-4 text-green-500" />
                <span>Offline schematics</span>
              </li>
            </ul>
            <button className="w-full flex items-center justify-center space-x-2 bg-gradient-to-r from-green-600 to-emerald-500 hover:from-green-500 hover:to-emerald-400 px-6 py-3 rounded-xl font-semibold transition-all">
              <Download className="w-5 h-5" />
              <span>Download .APK</span>
            </button>
          </div>
        </div>
        
        <p className="text-center text-gray-500 mt-8">
          Or download from GitHub Releases → 
          <a href="https://github.com/repairai/repairai/releases" className="text-blue-400 hover:underline ml-1">
            View Releases
            <ExternalLink className="w-4 h-4 inline ml-1" />
          </a>
        </p>
      </div>
    </section>
  )
}

// Footer
function Footer() {
  return (
    <footer className="bg-dark-950 border-t border-dark-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid md:grid-cols-4 gap-8">
          <div>
            <div className="flex items-center space-x-2 mb-4">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-cyan-400 rounded-xl flex items-center justify-center">
                <Cpu className="w-6 h-6 text-white" />
              </div>
              <span className="text-xl font-bold gradient-text">RepairAI</span>
            </div>
            <p className="text-gray-400">
              AI-powered mobile repair assistant built for technicians, by technicians.
            </p>
          </div>
          
          <div>
            <h4 className="font-semibold mb-4">Product</h4>
            <ul className="space-y-2 text-gray-400">
              <li><a href="#features" className="hover:text-white transition-colors">Features</a></li>
              <li><a href="#download" className="hover:text-white transition-colors">Download</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Changelog</a></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-semibold mb-4">Community</h4>
            <ul className="space-y-2 text-gray-400">
              <li><a href="https://github.com/repairai/repairai" className="hover:text-white transition-colors">GitHub</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Discord</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Telegram</a></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-semibold mb-4">Legal</h4>
            <ul className="space-y-2 text-gray-400">
              <li><a href="#" className="hover:text-white transition-colors">Privacy Policy</a></li>
              <li><a href="#" className="hover:text-white transition-colors">Terms of Service</a></li>
              <li><a href="#" className="hover:text-white transition-colors">License (MIT)</a></li>
            </ul>
          </div>
        </div>
        
        <div className="border-t border-dark-800 mt-12 pt-8 flex flex-col md:flex-row items-center justify-between">
          <p className="text-gray-500">© 2026 RepairAI. Open source under MIT license.</p>
          <div className="flex items-center space-x-4 mt-4 md:mt-0">
            <a href="https://github.com/repairai/repairai" className="text-gray-400 hover:text-white transition-colors">
              <Github className="w-6 h-6" />
            </a>
            <Globe className="w-6 h-6 text-gray-400" />
          </div>
        </div>
      </div>
    </footer>
  )
}

// Main Page
export default function Home() {
  return (
    <main className="bg-dark-950 min-h-screen">
      <Navbar />
      <Hero />
      <Features />
      <HowItWorks />
      <Community />
      <Download />
      <Footer />
    </main>
  )
}

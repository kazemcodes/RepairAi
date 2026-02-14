import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'RepairAI - AI-Powered Mobile Repair Assistant',
  description: 'Free, open-source mobile repair assistant with AI-powered schematics, solutions, and chat support. Built for repair technicians by the community.',
  keywords: ['mobile repair', 'AI repair', 'phone repair', 'circuit diagrams', 'repair guides', 'open source'],
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}

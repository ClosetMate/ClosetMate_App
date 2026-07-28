import React from 'react';
import { HomeIcon, GridIcon, SparklesIcon, UserIcon } from 'lucide-react';
import { motion } from 'framer-motion';
export type TabType = 'home' | 'closet' | 'swipe' | 'profile';
interface BottomNavProps {
  activeTab: TabType;
  setActiveTab: (tab: TabType) => void;
}
export function BottomNav({ activeTab, setActiveTab }: BottomNavProps) {
  const tabs = [
  {
    id: 'home',
    icon: HomeIcon,
    label: 'Home'
  },
  {
    id: 'closet',
    icon: GridIcon,
    label: 'Closet'
  },
  {
    id: 'swipe',
    icon: SparklesIcon,
    label: 'Discover'
  },
  {
    id: 'profile',
    icon: UserIcon,
    label: 'Profile'
  }] as
  const;
  return (
    <div className="absolute bottom-0 w-full h-20 bg-white/90 backdrop-blur-md border-t border-gray-100 flex justify-around items-center px-6 pb-4 z-50">
      {tabs.map((tab) => {
        const isActive = activeTab === tab.id;
        const Icon = tab.icon;
        return (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className="relative flex flex-col items-center justify-center w-16 h-full outline-none tap-highlight-transparent">
            
            <motion.div
              animate={{
                scale: isActive ? 1.1 : 1,
                color: isActive ? '#1A1A1A' : '#9CA3AF'
              }}
              transition={{
                type: 'spring',
                stiffness: 400,
                damping: 25
              }}>
              
              <Icon strokeWidth={isActive ? 2.5 : 2} size={24} />
            </motion.div>

            {isActive &&
            <motion.div
              layoutId="nav-indicator"
              className="absolute -bottom-1 w-1 h-1 bg-brand-900 rounded-full"
              transition={{
                type: 'spring',
                stiffness: 400,
                damping: 30
              }} />

            }
          </button>);

      })}
    </div>);

}
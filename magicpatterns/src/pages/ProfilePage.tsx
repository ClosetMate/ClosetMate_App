import React from 'react';
import { motion } from 'framer-motion';
import {
  SettingsIcon,
  ChevronRightIcon,
  RulerIcon,
  HeartIcon,
  ShoppingBagIcon,
  SparklesIcon } from
'lucide-react';
export function ProfilePage() {
  const menuItems = [
  {
    icon: RulerIcon,
    label: 'My Measurements',
    value: 'Updated 2w ago'
  },
  {
    icon: HeartIcon,
    label: 'Saved Outfits',
    value: '24 items'
  },
  {
    icon: ShoppingBagIcon,
    label: 'Wishlist',
    value: '12 items'
  },
  {
    icon: SparklesIcon,
    label: 'Style Preferences',
    value: 'Minimalist'
  }];

  return (
    <motion.div
      className="h-full w-full bg-[#F8FAFB] overflow-y-auto no-scrollbar pb-24"
      initial={{
        opacity: 0
      }}
      animate={{
        opacity: 1
      }}
      exit={{
        opacity: 0
      }}>
      
      {/* Header */}
      <header className="px-6 pt-12 pb-6 flex justify-end">
        <button className="p-2 text-brand-900">
          <SettingsIcon size={24} strokeWidth={1.5} />
        </button>
      </header>

      {/* Profile Info */}
      <div className="px-6 mb-10 flex flex-col items-center text-center">
        <div className="w-24 h-24 rounded-full overflow-hidden mb-4 shadow-soft bg-white p-1">
          <img
            src="https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400"
            alt="Profile"
            className="w-full h-full object-cover rounded-full" />
          
        </div>
        <h1 className="font-display text-3xl tracking-wide uppercase text-brand-900 mb-1">
          Elena Rostova
        </h1>
        <p className="font-fashion text-sm text-brand-500">London, UK</p>
      </div>

      {/* Menu List */}
      <div className="px-6 space-y-3">
        {menuItems.map((item, idx) => {
          const Icon = item.icon;
          return (
            <motion.button
              key={idx}
              whileTap={{
                scale: 0.98
              }}
              className="w-full bg-white p-4 rounded-2xl flex items-center justify-between shadow-soft">
              
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-full bg-brand-50 flex items-center justify-center text-brand-900">
                  <Icon size={20} strokeWidth={1.5} />
                </div>
                <div className="text-left">
                  <p className="text-sm font-semibold text-brand-900">
                    {item.label}
                  </p>
                  <p className="text-xs font-medium text-brand-400 mt-0.5">
                    {item.value}
                  </p>
                </div>
              </div>
              <ChevronRightIcon size={20} className="text-brand-300" />
            </motion.button>);

        })}
      </div>

      {/* Logout */}
      <div className="px-6 mt-10">
        <button className="w-full py-4 text-sm font-semibold text-red-500 bg-red-50 rounded-2xl">
          Log Out
        </button>
      </div>
    </motion.div>);

}
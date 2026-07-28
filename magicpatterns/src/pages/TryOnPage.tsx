import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  ChevronLeftIcon,
  DownloadIcon,
  HeartIcon,
  RefreshCwIcon,
  SparklesIcon } from
'lucide-react';
const OUTFITS = [
{
  id: 1,
  image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800',
  name: 'Summer Casual'
},
{
  id: 2,
  image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800',
  name: 'Office Chic'
},
{
  id: 3,
  image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
  name: 'Evening Wear'
}];

export function TryOnPage({ onBack }: {onBack: () => void;}) {
  const [activeOutfit, setActiveOutfit] = useState(0);
  const [isGenerating, setIsGenerating] = useState(false);
  const handleGenerate = () => {
    setIsGenerating(true);
    setTimeout(() => {
      setActiveOutfit((prev) => (prev + 1) % OUTFITS.length);
      setIsGenerating(false);
    }, 800);
  };
  return (
    <motion.div
      className="h-full w-full bg-[#EAEAEA] flex flex-col relative"
      initial={{
        opacity: 0,
        y: 20
      }}
      animate={{
        opacity: 1,
        y: 0
      }}
      exit={{
        opacity: 0,
        y: 20
      }}>
      
      {/* Header */}
      <header className="absolute top-0 left-0 right-0 flex items-center justify-between px-6 pt-12 pb-4 z-20 bg-gradient-to-b from-black/30 to-transparent">
        <button
          onClick={onBack}
          className="p-2 -ml-2 text-white bg-black/20 rounded-full backdrop-blur-md">
          
          <ChevronLeftIcon size={24} strokeWidth={2} />
        </button>
        <div className="flex gap-3">
          <button className="p-2 text-white bg-black/20 rounded-full backdrop-blur-md">
            <RefreshCwIcon size={20} strokeWidth={2} />
          </button>
          <button className="p-2 text-white bg-black/20 rounded-full backdrop-blur-md">
            <DownloadIcon size={20} strokeWidth={2} />
          </button>
        </div>
      </header>

      {/* Main Avatar Area */}
      <div className="flex-1 relative w-full overflow-hidden">
        <AnimatePresence mode="wait">
          <motion.img
            key={activeOutfit}
            src={OUTFITS[activeOutfit].image}
            alt="Virtual Try On"
            className="w-full h-full object-cover"
            initial={{
              opacity: 0,
              scale: 1.05
            }}
            animate={{
              opacity: 1,
              scale: 1
            }}
            exit={{
              opacity: 0
            }}
            transition={{
              duration: 0.4
            }} />
          
        </AnimatePresence>

        {isGenerating &&
        <div className="absolute inset-0 bg-white/40 backdrop-blur-sm flex items-center justify-center z-10">
            <motion.div
            animate={{
              rotate: 360
            }}
            transition={{
              repeat: Infinity,
              duration: 1,
              ease: 'linear'
            }}>
            
              <SparklesIcon size={32} className="text-brand-900" />
            </motion.div>
          </div>
        }
      </div>

      {/* Bottom Controls */}
      <div className="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl p-6 pb-10 shadow-[0_-10px_40px_rgba(0,0,0,0.1)] z-20">
        <div className="w-12 h-1.5 bg-gray-200 rounded-full mx-auto mb-6" />

        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="font-display text-xl tracking-wide uppercase text-brand-900">
              {OUTFITS[activeOutfit].name}
            </h2>
            <p className="font-fashion text-sm text-brand-500">
              AI Generated Combination
            </p>
          </div>
          <button className="w-10 h-10 rounded-full bg-brand-50 flex items-center justify-center text-brand-900">
            <HeartIcon size={20} strokeWidth={2} />
          </button>
        </div>

        <div className="flex gap-3 overflow-x-auto no-scrollbar pb-2">
          {OUTFITS.map((outfit, idx) =>
          <button
            key={outfit.id}
            onClick={() => setActiveOutfit(idx)}
            className={`relative shrink-0 w-20 h-20 rounded-xl overflow-hidden border-2 transition-colors ${activeOutfit === idx ? 'border-brand-900' : 'border-transparent'}`}>
            
              <img
              src={outfit.image}
              alt="Thumbnail"
              className="w-full h-full object-cover" />
            
            </button>
          )}

          <button
            onClick={handleGenerate}
            className="shrink-0 w-20 h-20 rounded-xl bg-brand-50 border border-brand-100 flex flex-col items-center justify-center gap-1 text-brand-900">
            
            <SparklesIcon size={20} />
            <span className="text-[10px] font-semibold uppercase tracking-wider">
              Generate
            </span>
          </button>
        </div>
      </div>
    </motion.div>);

}
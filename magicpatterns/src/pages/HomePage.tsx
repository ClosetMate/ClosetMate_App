import React, { Children } from 'react';
import { motion } from 'framer-motion';
import { SearchIcon, UserIcon, HeartIcon, SparklesIcon } from 'lucide-react';
const MOCK_LIKES = [
{
  id: 1,
  brand: 'Zara',
  price: '$89',
  image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400'
},
{
  id: 2,
  brand: 'COS',
  price: '$120',
  image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400'
},
{
  id: 3,
  brand: 'Massimo Dutti',
  price: '$150',
  image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'
},
{
  id: 4,
  brand: 'Arket',
  price: '$45',
  image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400'
}];

const MOCK_DISCOVER = [
{
  id: 1,
  brand: 'Acne Studios',
  price: '$320',
  image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400'
},
{
  id: 2,
  brand: 'A.P.C.',
  price: '$210',
  image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=400'
},
{
  id: 3,
  brand: 'Uniqlo U',
  price: '$60',
  image: 'https://images.unsplash.com/photo-1611923134239-b9be5816e23c?w=400'
}];

const containerVariants = {
  hidden: {
    opacity: 0
  },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1
    }
  }
};
const itemVariants = {
  hidden: {
    opacity: 0,
    y: 20
  },
  show: {
    opacity: 1,
    y: 0,
    transition: {
      type: 'spring',
      stiffness: 300,
      damping: 24
    }
  }
};
export function HomePage({ onTryOn }: {onTryOn: () => void;}) {
  return (
    <motion.div
      className="h-full w-full overflow-y-auto no-scrollbar bg-white pb-24"
      initial="hidden"
      animate="show"
      exit={{
        opacity: 0
      }}
      variants={containerVariants}>
      
      {/* Header */}
      <header className="flex items-center justify-between px-6 pt-12 pb-4 sticky top-0 bg-white/90 backdrop-blur-md z-20">
        <button className="p-2 -ml-2 text-brand-900">
          <UserIcon size={22} strokeWidth={2} />
        </button>
        <h1 className="font-display text-2xl tracking-wide text-brand-900 uppercase">
          ClosetMate
        </h1>
        <button className="p-2 -mr-2 text-brand-900">
          <SearchIcon size={22} strokeWidth={2} />
        </button>
      </header>

      {/* AI Outfit of the Day */}
      <motion.section variants={itemVariants} className="px-6 mt-2 mb-10">
        <div className="flex items-center justify-between mb-4">
          <h2 className="font-fashion text-sm font-medium text-brand-500 uppercase tracking-[0.2em]">
            AI Outfit of the Day
          </h2>
          <SparklesIcon size={16} className="text-brand-300" />
        </div>

        <div className="relative w-full aspect-[4/5] rounded-3xl overflow-hidden shadow-float group">
          <img
            src="https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800"
            alt="AI Generated Outfit"
            className="w-full h-full object-cover" />
          
          <div className="absolute inset-0 bg-gradient-to-t from-black/50 via-black/10 to-transparent" />

          <button className="absolute top-4 right-4 p-3 bg-white/20 backdrop-blur-md rounded-full text-white hover:bg-white/30 transition-colors">
            <HeartIcon size={20} strokeWidth={2} />
          </button>

          <div className="absolute bottom-6 left-6 right-6">
            <motion.button
              whileTap={{
                scale: 0.97
              }}
              onClick={onTryOn}
              className="w-full bg-white text-brand-900 py-4 rounded-full font-semibold text-sm shadow-float flex items-center justify-center gap-2">
              
              <SparklesIcon size={18} />
              Try On Outfit
            </motion.button>
          </div>
        </div>
      </motion.section>

      {/* Your Likes */}
      <motion.section variants={itemVariants} className="mb-10">
        <div className="px-6 mb-4 flex items-center justify-between">
          <h2 className="font-display text-2xl tracking-wide text-brand-900 uppercase">
            Your Likes
          </h2>
          <button className="text-sm text-brand-500 font-semibold">
            See All
          </button>
        </div>
        <div className="flex overflow-x-auto no-scrollbar px-6 gap-5 pb-4 snap-x">
          {MOCK_LIKES.map((item) =>
          <motion.div
            key={item.id}
            className="snap-start shrink-0 w-[160px]"
            whileTap={{
              scale: 0.96
            }}>
            
              <div className="relative aspect-[3/4] rounded-2xl overflow-hidden bg-brand-50 mb-3 shadow-soft">
                <img
                src={item.image}
                alt={item.brand}
                className="w-full h-full object-cover" />
              
                <div className="absolute top-2 right-2 p-1.5 bg-white/80 backdrop-blur-sm rounded-full text-red-500">
                  <HeartIcon size={14} strokeWidth={2.5} fill="currentColor" />
                </div>
              </div>
              <div className="flex justify-between items-center px-1">
                <p className="font-fashion text-sm font-medium text-brand-900 truncate">
                  {item.brand}
                </p>
                <p className="text-sm font-medium text-brand-500">
                  {item.price}
                </p>
              </div>
            </motion.div>
          )}
        </div>
      </motion.section>

      {/* Discover */}
      <motion.section variants={itemVariants} className="mb-6">
        <div className="px-6 mb-4">
          <h2 className="font-display text-2xl tracking-wide text-brand-900 uppercase">
            Discover
          </h2>
        </div>
        <div className="flex overflow-x-auto no-scrollbar px-6 gap-5 pb-4 snap-x">
          {MOCK_DISCOVER.map((item) =>
          <motion.div
            key={item.id}
            className="snap-start shrink-0 w-[220px]"
            whileTap={{
              scale: 0.96
            }}>
            
              <div className="relative aspect-[4/5] rounded-2xl overflow-hidden bg-brand-50 mb-3 shadow-soft">
                <img
                src={item.image}
                alt={item.brand}
                className="w-full h-full object-cover" />
              
                <button className="absolute top-3 right-3 p-2 bg-white/50 backdrop-blur-sm rounded-full text-brand-900">
                  <HeartIcon size={16} strokeWidth={2} />
                </button>
              </div>
              <div className="flex justify-between items-center px-1">
                <p className="font-fashion text-base font-medium text-brand-900">
                  {item.brand}
                </p>
                <p className="text-base font-medium text-brand-500">
                  {item.price}
                </p>
              </div>
            </motion.div>
          )}
        </div>
      </motion.section>
    </motion.div>);

}
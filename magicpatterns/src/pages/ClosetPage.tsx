import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { SearchIcon, PlusIcon, HeartIcon } from 'lucide-react';
const CATEGORIES = ['All', 'Tops', 'Pants', 'Shoes', 'Jackets'];
const WARDROBE = [
{
  id: 1,
  category: 'Tops',
  name: 'Linen Shirt',
  image: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=400'
},
{
  id: 2,
  category: 'Pants',
  name: 'Wide Trousers',
  image: 'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400'
},
{
  id: 3,
  category: 'Shoes',
  name: 'Leather Loafers',
  image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'
},
{
  id: 4,
  category: 'Jackets',
  name: 'Wool Coat',
  image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400'
},
{
  id: 5,
  category: 'Tops',
  name: 'Cotton T-Shirt',
  image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400'
},
{
  id: 6,
  category: 'Jackets',
  name: 'Blazer',
  image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=400'
}];

const LIKES = [
{
  id: 101,
  brand: 'Zara',
  name: 'Pleated Midi Dress',
  price: '$89',
  image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400'
},
{
  id: 102,
  brand: 'COS',
  name: 'Oversized Wool Coat',
  price: '$250',
  image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400'
},
{
  id: 103,
  brand: 'Massimo Dutti',
  name: 'Linen Blend Blazer',
  price: '$199',
  image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=400'
},
{
  id: 104,
  brand: 'Arket',
  name: 'Heavyweight T-Shirt',
  price: '$45',
  image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400'
}];

type TabType = 'closet' | 'likes';
export function ClosetPage() {
  const [activeMainTab, setActiveMainTab] = useState<TabType>('closet');
  const [activeCategory, setActiveCategory] = useState('All');
  const filteredWardrobe =
  activeCategory === 'All' ?
  WARDROBE :
  WARDROBE.filter((item) => item.category === activeCategory);
  return (
    <motion.div
      className="h-full w-full bg-white flex flex-col"
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
      <header className="px-6 pt-12 pb-4 sticky top-0 bg-white/90 backdrop-blur-md z-20">
        <div className="flex items-center justify-between mb-6">
          <h1 className="font-display text-3xl tracking-wide text-brand-900 uppercase">
            My Wardrobe
          </h1>
          <div className="flex gap-3">
            <button className="p-2 text-brand-900 bg-brand-50 rounded-full">
              <SearchIcon size={20} strokeWidth={2} />
            </button>
            <button className="p-2 text-white bg-brand-900 rounded-full shadow-soft">
              <PlusIcon size={20} strokeWidth={2} />
            </button>
          </div>
        </div>

        {/* Main Tabs Segmented Control */}
        <div className="flex p-1 bg-brand-50 rounded-xl">
          <button
            onClick={() => setActiveMainTab('closet')}
            className={`flex-1 py-2 text-sm font-semibold rounded-lg transition-all ${activeMainTab === 'closet' ? 'bg-white text-brand-900 shadow-sm' : 'text-brand-500 hover:text-brand-900'}`}>
            
            Closet
          </button>
          <button
            onClick={() => setActiveMainTab('likes')}
            className={`flex-1 py-2 text-sm font-semibold rounded-lg transition-all ${activeMainTab === 'likes' ? 'bg-white text-brand-900 shadow-sm' : 'text-brand-500 hover:text-brand-900'}`}>
            
            Likes
          </button>
        </div>
      </header>

      {/* Content Area */}
      <div className="flex-1 overflow-y-auto no-scrollbar pb-28">
        <AnimatePresence mode="wait">
          {activeMainTab === 'closet' ?
          <motion.div
            key="closet"
            initial={{
              opacity: 0,
              x: -20
            }}
            animate={{
              opacity: 1,
              x: 0
            }}
            exit={{
              opacity: 0,
              x: -20
            }}
            transition={{
              duration: 0.2
            }}>
            
              {/* Filters */}
              <div className="px-6 py-2 mb-4">
                <div className="flex gap-2 overflow-x-auto no-scrollbar pb-2">
                  {CATEGORIES.map((cat) =>
                <button
                  key={cat}
                  onClick={() => setActiveCategory(cat)}
                  className={`px-5 py-2 rounded-full text-sm font-semibold whitespace-nowrap transition-colors ${activeCategory === cat ? 'bg-brand-900 text-white' : 'bg-brand-50 text-brand-500 hover:bg-brand-100'}`}>
                  
                      {cat}
                    </button>
                )}
                </div>
              </div>

              {/* Grid */}
              <div className="px-6">
                <motion.div className="grid grid-cols-2 gap-4" layout>
                  {filteredWardrobe.map((item) =>
                <motion.div
                  key={item.id}
                  layout
                  initial={{
                    opacity: 0,
                    scale: 0.9
                  }}
                  animate={{
                    opacity: 1,
                    scale: 1
                  }}
                  exit={{
                    opacity: 0,
                    scale: 0.9
                  }}
                  whileTap={{
                    scale: 0.96
                  }}
                  className="flex flex-col gap-2">
                  
                      <div className="relative aspect-[3/4] rounded-2xl overflow-hidden bg-brand-50 shadow-soft">
                        <img
                      src={item.image}
                      alt={item.name}
                      className="w-full h-full object-cover mix-blend-multiply" />
                    
                      </div>
                      <div className="px-1">
                        <p className="font-fashion text-sm font-medium text-brand-900 truncate">
                          {item.name}
                        </p>
                        <p className="text-xs text-brand-400">
                          {item.category}
                        </p>
                      </div>
                    </motion.div>
                )}
                </motion.div>
              </div>
            </motion.div> :

          <motion.div
            key="likes"
            initial={{
              opacity: 0,
              x: 20
            }}
            animate={{
              opacity: 1,
              x: 0
            }}
            exit={{
              opacity: 0,
              x: 20
            }}
            transition={{
              duration: 0.2
            }}
            className="px-6 pt-4">
            
              <div className="grid grid-cols-2 gap-4">
                {LIKES.map((item) =>
              <motion.div
                key={item.id}
                layout
                initial={{
                  opacity: 0,
                  scale: 0.9
                }}
                animate={{
                  opacity: 1,
                  scale: 1
                }}
                whileTap={{
                  scale: 0.96
                }}
                className="flex flex-col gap-2">
                
                    <div className="relative aspect-[3/4] rounded-2xl overflow-hidden bg-brand-50 shadow-soft">
                      <img
                    src={item.image}
                    alt={item.name}
                    className="w-full h-full object-cover" />
                  
                      <div className="absolute top-2 right-2 p-1.5 bg-white/80 backdrop-blur-sm rounded-full text-red-500">
                        <HeartIcon
                      size={14}
                      strokeWidth={2.5}
                      fill="currentColor" />
                    
                      </div>
                    </div>
                    <div className="px-1">
                      <p className="font-fashion text-sm font-medium text-brand-900 truncate">
                        {item.brand}
                      </p>
                      <div className="flex justify-between items-center">
                        <p className="font-fashion text-xs text-brand-500 truncate pr-2">
                          {item.name}
                        </p>
                        <p className="text-sm font-medium text-brand-900">
                          {item.price}
                        </p>
                      </div>
                    </div>
                  </motion.div>
              )}
              </div>
            </motion.div>
          }
        </AnimatePresence>
      </div>
    </motion.div>);

}
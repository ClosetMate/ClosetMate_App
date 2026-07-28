import React, { useState } from 'react';
import {
  motion,
  useMotionValue,
  useTransform,
  AnimatePresence } from
'framer-motion';
import { ShoppingBagIcon, HeartIcon, SparklesIcon, XIcon } from 'lucide-react';
const SWIPE_CARDS = [
{
  id: 1,
  brand: 'COS',
  name: 'Oversized Wool Coat',
  price: '$250',
  image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=800'
},
{
  id: 2,
  brand: 'Zara',
  name: 'Pleated Midi Dress',
  price: '$89',
  image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=800'
},
{
  id: 3,
  brand: 'Massimo Dutti',
  name: 'Linen Blend Blazer',
  price: '$199',
  image: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=800'
},
{
  id: 4,
  brand: 'Arket',
  name: 'Heavyweight T-Shirt',
  price: '$45',
  image: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=800'
}];

export function SwipeShopPage({ onTryOn }: {onTryOn: () => void;}) {
  const [cards, setCards] = useState(SWIPE_CARDS);
  const x = useMotionValue(0);
  const y = useMotionValue(0);
  const rotate = useTransform(x, [-200, 200], [-10, 10]);
  const opacity = useTransform(
    x,
    [-200, -100, 0, 100, 200],
    [0.5, 1, 1, 1, 0.5]
  );
  // Visual feedback opacities based on drag direction
  const likeOpacity = useTransform(x, [0, 100], [0, 1]);
  const skipOpacity = useTransform(x, [0, -100], [0, 1]);
  const cartOpacity = useTransform(y, [0, -100], [0, 1]);
  const handleDragEnd = (event: any, info: any) => {
    const threshold = 100;
    if (
    info.offset.x > threshold ||
    info.offset.x < -threshold ||
    info.offset.y < -threshold)
    {
      // Swipe action triggered
      if (info.offset.y < -threshold) {
        // Swipe up to add to cart
        console.log('Added to cart');
      }
      setCards((prev) => prev.slice(1));
      x.set(0);
      y.set(0);
    }
  };
  const handleAction = (action: 'skip' | 'like' | 'try' | 'cart') => {
    if (action === 'try') {
      onTryOn();
      return;
    }
    setCards((prev) => prev.slice(1));
  };
  return (
    <motion.div
      className="h-full w-full bg-brand-50 flex flex-col relative overflow-hidden"
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
      <header className="flex items-center justify-between px-6 pt-12 pb-4 z-10">
        <h1 className="font-display text-2xl tracking-wide text-brand-900 uppercase">
          Discover Styles
        </h1>
        <button className="p-2 -mr-2 text-brand-900 relative">
          <ShoppingBagIcon size={24} strokeWidth={1.5} />
          <span className="absolute top-1 right-1 w-2 h-2 bg-brand-300 rounded-full"></span>
        </button>
      </header>

      {/* Cards Area */}
      <div className="flex-1 relative w-full flex items-center justify-center px-4 pb-32">
        <AnimatePresence>
          {cards.length > 0 ?
          cards.map((card, index) => {
            const isTop = index === 0;
            return (
              <motion.div
                key={card.id}
                className="absolute w-[calc(100%-2rem)] max-w-[380px] aspect-[3/4.5] bg-white rounded-[32px] shadow-float overflow-hidden"
                style={{
                  zIndex: cards.length - index,
                  x: isTop ? x : 0,
                  y: isTop ? y : index * 8,
                  rotate: isTop ? rotate : 0,
                  scale: isTop ? 1 : 1 - index * 0.04,
                  opacity: isTop ? opacity : 1
                }}
                drag={isTop ? true : false}
                dragConstraints={{
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0
                }}
                onDragEnd={isTop ? handleDragEnd : undefined}
                initial={{
                  scale: 0.95,
                  opacity: 0
                }}
                animate={{
                  scale: isTop ? 1 : 1 - index * 0.04,
                  opacity: 1
                }}
                exit={{
                  x: x.get() > 50 ? 300 : x.get() < -50 ? -300 : 0,
                  y: y.get() < -50 ? -300 : 0,
                  opacity: 0,
                  transition: {
                    duration: 0.2
                  }
                }}
                transition={{
                  type: 'spring',
                  stiffness: 300,
                  damping: 20
                }}>
                
                  <img
                  src={card.image}
                  alt={card.name}
                  className="w-full h-full object-cover pointer-events-none" />
                

                  {/* Visual Feedback Overlays */}
                  {isTop &&
                <>
                      {/* Like Overlay */}
                      <motion.div
                    className="absolute top-12 left-8 border-4 border-green-500 text-green-500 rounded-xl px-4 py-2 font-bold text-3xl tracking-widest uppercase rotate-[-15deg] pointer-events-none"
                    style={{
                      opacity: likeOpacity
                    }}>
                    
                        LIKE
                      </motion.div>

                      {/* Skip Overlay */}
                      <motion.div
                    className="absolute top-12 right-8 border-4 border-red-500 text-red-500 rounded-xl px-4 py-2 font-bold text-3xl tracking-widest uppercase rotate-[15deg] pointer-events-none"
                    style={{
                      opacity: skipOpacity
                    }}>
                    
                        NOPE
                      </motion.div>

                      {/* Cart Overlay */}
                      <motion.div
                    className="absolute bottom-32 left-1/2 -translate-x-1/2 border-4 border-brand-300 text-brand-300 rounded-xl px-4 py-2 font-bold text-2xl tracking-widest uppercase pointer-events-none bg-white/80 backdrop-blur-sm"
                    style={{
                      opacity: cartOpacity
                    }}>
                    
                        CART
                      </motion.div>
                    </>
                }

                  {/* Card Info Overlay */}
                  <div className="absolute bottom-0 left-0 right-0 p-8 bg-gradient-to-t from-black/80 via-black/30 to-transparent text-white pointer-events-none">
                    <h2 className="text-3xl font-bold tracking-tight mb-2">
                      {card.brand}
                    </h2>
                    <div className="flex justify-between items-end">
                      <p className="text-white/90 font-medium text-lg">
                        {card.name}
                      </p>
                      <p className="text-2xl font-semibold">{card.price}</p>
                    </div>
                  </div>
                </motion.div>);

          }) :

          <div className="text-center text-brand-500">
              <SparklesIcon size={48} className="mx-auto mb-4 opacity-20" />
              <p>You've seen all styles for today.</p>
            </div>
          }
        </AnimatePresence>
      </div>

      {/* Action Buttons */}
      {cards.length > 0 &&
      <div className="absolute bottom-24 left-0 right-0 flex justify-center items-center gap-6 z-20 px-6">
          <motion.button
          whileTap={{
            scale: 0.9
          }}
          onClick={() => handleAction('skip')}
          className="w-14 h-14 rounded-full bg-white shadow-float flex items-center justify-center text-red-500 border border-gray-100">
          
            <XIcon size={24} strokeWidth={2.5} />
          </motion.button>

          <motion.button
          whileTap={{
            scale: 0.9
          }}
          onClick={() => handleAction('cart')}
          className="w-16 h-16 rounded-full bg-brand-900 shadow-float flex items-center justify-center text-white">
          
            <ShoppingBagIcon size={26} strokeWidth={2} />
          </motion.button>

          <motion.button
          whileTap={{
            scale: 0.9
          }}
          onClick={() => handleAction('like')}
          className="w-14 h-14 rounded-full bg-white shadow-float flex items-center justify-center text-green-500 border border-gray-100">
          
            <HeartIcon size={24} strokeWidth={2.5} />
          </motion.button>
        </div>
      }

      {/* Try On Floating Button */}
      {cards.length > 0 &&
      <motion.button
        whileTap={{
          scale: 0.95
        }}
        onClick={() => handleAction('try')}
        className="absolute bottom-6 left-1/2 -translate-x-1/2 px-6 py-2.5 bg-white/80 backdrop-blur-md rounded-full shadow-soft text-brand-900 font-semibold text-sm flex items-center gap-2 z-20 border border-white/50">
        
          <SparklesIcon size={16} />
          Virtual Try-On
        </motion.button>
      }
    </motion.div>);

}
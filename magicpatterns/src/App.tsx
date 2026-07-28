import React, { useState } from 'react';
import { AnimatePresence } from 'framer-motion';
import { BottomNav, TabType } from './components/BottomNav';
import { HomePage } from './pages/HomePage';
import { SwipeShopPage } from './pages/SwipeShopPage';
import { TryOnPage } from './pages/TryOnPage';
import { ClosetPage } from './pages/ClosetPage';
import { ProfilePage } from './pages/ProfilePage';
export function App() {
  const [activeTab, setActiveTab] = useState<TabType>('home');
  const [isTryOnActive, setIsTryOnActive] = useState(false);
  const renderScreen = () => {
    if (isTryOnActive) {
      return <TryOnPage onBack={() => setIsTryOnActive(false)} />;
    }
    switch (activeTab) {
      case 'home':
        return <HomePage onTryOn={() => setIsTryOnActive(true)} />;
      case 'swipe':
        return <SwipeShopPage onTryOn={() => setIsTryOnActive(true)} />;
      case 'closet':
        return <ClosetPage />;
      case 'profile':
        return <ProfilePage />;
      default:
        return <HomePage onTryOn={() => setIsTryOnActive(true)} />;
    }
  };
  return (
    <div className="min-h-screen w-full bg-gray-100 flex items-center justify-center p-0 sm:p-4 md:p-8">
      {/* Mobile Device Container Constraint */}
      <div className="w-full h-[100dvh] sm:h-[844px] max-w-[390px] bg-white sm:rounded-[40px] sm:shadow-2xl relative overflow-hidden flex flex-col sm:border-[8px] border-gray-900">
        {/* Dynamic Screen Content */}
        <div className="flex-1 relative overflow-hidden">
          <AnimatePresence mode="wait">{renderScreen()}</AnimatePresence>
        </div>

        {/* Bottom Navigation (Hidden during Try-On) */}
        <AnimatePresence>
          {!isTryOnActive &&
          <BottomNav activeTab={activeTab} setActiveTab={setActiveTab} />
          }
        </AnimatePresence>
      </div>
    </div>);

}
"use client";

import Navbar from './Navbar';
import Footer from './Footer';
import LightCone from './ui/LightCone';
import PageTransition from './PageTransition';
import ScrollToTop from './ui/ScrollToTop';
import CookieConsent from './CookieConsent';

type LayoutProps = {
  children: React.ReactNode;
};

export default function Layout({ children }: LayoutProps) {
  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 to-black">
      <LightCone 
        color="#FFD100" 
        intensity={0.05} 
        effect="shifting"
        className="min-h-screen"
      >
        <Navbar />
        <PageTransition>
          <main>{children}</main>
        </PageTransition>
        <Footer />
        <ScrollToTop />
        <CookieConsent />
      </LightCone>
    </div>
  );
}

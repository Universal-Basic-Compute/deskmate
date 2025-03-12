"use client";

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import Image from 'next/image';
import GradientText from './ui/GradientText';
import Button from './ui/Button';

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  
  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };
    
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);
  
  return (
    <motion.header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled ? 'bg-gray-900/80 backdrop-blur-md py-2' : 'bg-transparent py-4'
      }`}
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="container mx-auto px-4 flex justify-between items-center">
        <a href="#" className="flex items-center">
          <Image src="/logo.svg" alt="DeskMate" width={40} height={40} className="mr-2" />
          <GradientText className="text-2xl font-bold">DeskMate</GradientText>
        </a>
        
        <nav className="hidden md:flex items-center space-x-8">
          <a href="#features" className="text-gray-300 hover:text-white transition-colors">Features</a>
          <a href="#how-it-works" className="text-gray-300 hover:text-white transition-colors">How It Works</a>
          <a href="#pricing" className="text-gray-300 hover:text-white transition-colors">Pricing</a>
          <a href="#faq" className="text-gray-300 hover:text-white transition-colors">FAQ</a>
          <Button href="#beta" variant="primary" size="sm">Join Beta</Button>
        </nav>
        
        <button 
          className="md:hidden text-white"
          onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
          </svg>
        </button>
      </div>
      
      {/* Mobile menu */}
      {isMobileMenuOpen && (
        <motion.div 
          className="md:hidden bg-gray-900/95 backdrop-blur-md"
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          exit={{ opacity: 0, height: 0 }}
        >
          <div className="container mx-auto px-4 py-4 flex flex-col space-y-4">
            <a href="#features" className="text-gray-300 hover:text-white transition-colors py-2">Features</a>
            <a href="#how-it-works" className="text-gray-300 hover:text-white transition-colors py-2">How It Works</a>
            <a href="#pricing" className="text-gray-300 hover:text-white transition-colors py-2">Pricing</a>
            <a href="#faq" className="text-gray-300 hover:text-white transition-colors py-2">FAQ</a>
            <Button href="#beta" variant="primary" size="sm">Join Beta</Button>
          </div>
        </motion.div>
      )}
    </motion.header>
  );
}

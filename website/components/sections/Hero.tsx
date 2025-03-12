"use client";

import { motion } from 'framer-motion';
import Image from 'next/image';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';
import Button from '../ui/Button';
import ParticleEffect from '../ui/ParticleEffect';
import { useState } from 'react';

export default function Hero() {
  const [showParticles, setShowParticles] = useState(false);
  
  return (
    <LightCone effect="breathing" className="min-h-screen flex items-center">
      <div className="container mx-auto px-4 py-20">
        <div className="flex flex-col lg:flex-row items-center">
          <div className="lg:w-1/2 mb-12 lg:mb-0">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.8 }}
            >
              <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6">
                Your Personal AI Tutor That <GradientText>Lights Up</GradientText> Your Learning
              </h1>
              
              <p className="text-xl mb-8 text-gray-300">
                DeskMate combines a smart desk lamp with AI tutoring to help students solve problems through guided discovery, not just answers.
              </p>
              
              <div className="relative">
                <Button 
                  size="lg" 
                  href="#beta"
                  onClick={() => setShowParticles(true)}
                >
                  Join the Beta Program
                </Button>
                <ParticleEffect trigger={showParticles} />
              </div>
            </motion.div>
          </div>
          
          <div className="lg:w-1/2">
            <motion.div
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.8, delay: 0.2 }}
              className="relative"
            >
              <div className="absolute inset-0 bg-gradient-to-r from-yellow-400/20 to-orange-500/20 rounded-xl blur-xl" />
              <div className="relative w-full h-[400px]">
                <Image 
                  src="/images/hero-lamp.png" 
                  alt="DeskMate Smart Lamp" 
                  fill
                  className="object-contain relative z-10 rounded-xl"
                  priority
                />
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    </LightCone>
  );
}

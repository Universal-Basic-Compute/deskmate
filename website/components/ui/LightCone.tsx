"use client";

import { motion } from 'framer-motion';
import { useEffect, useState } from 'react';

type LightConeProps = {
  children: React.ReactNode;
  color?: string;
  intensity?: number;
  effect?: 'static' | 'breathing' | 'pulsing' | 'shifting';
  className?: string;
};

export default function LightCone({
  children,
  color = '#FFD100',
  intensity = 0.15,
  effect = 'static',
  className = '',
}: LightConeProps) {
  const [animationProps, setAnimationProps] = useState({
    opacity: intensity,
    x: '0%',
    y: '0%',
  });

  useEffect(() => {
    if (effect === 'static') return;

    let interval: NodeJS.Timeout;
    
    if (effect === 'breathing') {
      interval = setInterval(() => {
        setAnimationProps(prev => ({
          ...prev,
          opacity: prev.opacity === intensity ? intensity * 1.3 : intensity,
        }));
      }, 2000);
    } else if (effect === 'pulsing') {
      interval = setInterval(() => {
        setAnimationProps(prev => ({
          ...prev,
          opacity: prev.opacity === intensity ? intensity * 1.5 : intensity,
        }));
      }, 1000);
    } else if (effect === 'shifting') {
      interval = setInterval(() => {
        setAnimationProps(prev => ({
          ...prev,
          x: prev.x === '0%' ? '2%' : '0%',
          y: prev.y === '0%' ? '2%' : '0%',
        }));
      }, 3000);
    }

    return () => clearInterval(interval);
  }, [effect, intensity]);

  return (
    <div className={`relative overflow-hidden ${className}`}>
      <motion.div
        className="absolute inset-0 pointer-events-none"
        animate={animationProps}
        transition={{ duration: 2, ease: 'easeInOut' }}
        style={{
          background: `radial-gradient(circle at center top, ${color}${Math.round(intensity * 255).toString(16)} 0%, transparent 70%)`,
        }}
      />
      {children}
    </div>
  );
}

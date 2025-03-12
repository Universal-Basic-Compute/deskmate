"use client";

import { useEffect, useRef } from 'react';
import { motion } from 'framer-motion';

type Particle = {
  id: number;
  x: number;
  y: number;
  size: number;
  color: string;
  opacity: number;
  speed: number;
  angle: number;
};

type ParticleEffectProps = {
  count?: number;
  colors?: string[];
  trigger?: boolean;
  className?: string;
};

export default function ParticleEffect({
  count = 20,
  colors = ['#FFD100', '#FF9500', '#9C27B0'],
  trigger = false,
  className = '',
}: ParticleEffectProps) {
  const particles = useRef<Particle[]>([]);
  
  useEffect(() => {
    if (!trigger) return;
    
    // Generate particles
    particles.current = Array.from({ length: count }, (_, i) => ({
      id: i,
      x: 50, // center x
      y: 50, // center y
      size: Math.random() * 8 + 2,
      color: colors[Math.floor(Math.random() * colors.length)],
      opacity: 1,
      speed: Math.random() * 30 + 10,
      angle: Math.random() * Math.PI * 2,
    }));
  }, [trigger, count, colors]);

  if (!trigger || particles.current.length === 0) {
    return null;
  }

  return (
    <div className={`absolute inset-0 overflow-hidden pointer-events-none ${className}`}>
      {particles.current.map((particle) => (
        <motion.div
          key={particle.id}
          className="absolute rounded-full"
          initial={{
            x: `${particle.x}%`,
            y: `${particle.y}%`,
            opacity: 1,
            scale: 0,
          }}
          animate={{
            x: `${particle.x + Math.cos(particle.angle) * particle.speed}%`,
            y: `${particle.y + Math.sin(particle.angle) * particle.speed}%`,
            opacity: 0,
            scale: 1,
          }}
          transition={{
            duration: 1 + Math.random(),
            ease: 'easeOut',
          }}
          style={{
            width: particle.size,
            height: particle.size,
            backgroundColor: particle.color,
          }}
        />
      ))}
    </div>
  );
}

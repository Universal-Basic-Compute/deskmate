"use client";

import { motion } from 'framer-motion';
import { useState } from 'react';

type ButtonProps = {
  children: React.ReactNode;
  onClick?: () => void;
  className?: string;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  href?: string;
  type?: 'button' | 'submit' | 'reset';
};

export default function Button({
  children,
  onClick,
  className = '',
  variant = 'primary',
  size = 'md',
  href,
  type = 'button',
}: ButtonProps) {
  const [isHovered, setIsHovered] = useState(false);
  
  const sizeClasses = {
    sm: 'py-2 px-4 text-sm',
    md: 'py-3 px-6 text-base',
    lg: 'py-4 px-8 text-lg',
  };
  
  const variantClasses = {
    primary: 'bg-gradient-to-r from-yellow-400 to-orange-500 text-gray-900 font-bold',
    secondary: 'bg-violet-700 text-white',
    outline: 'bg-transparent border-2 border-yellow-400 text-yellow-400',
  };
  
  const baseClasses = `rounded-lg transition-all duration-300 ${sizeClasses[size]} ${variantClasses[variant]} ${className}`;
  
  const ButtonContent = (
    <motion.div
      className="relative overflow-hidden"
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
      whileTap={{ scale: 0.98 }}
    >
      <div className={baseClasses}>
        {children}
      </div>
      {isHovered && (
        <motion.div
          className="absolute inset-0 pointer-events-none"
          initial={{ opacity: 0 }}
          animate={{ opacity: 0.4 }}
          exit={{ opacity: 0 }}
          style={{
            background: 'radial-gradient(circle at center, rgba(255,209,0,0.8) 0%, transparent 70%)',
          }}
        />
      )}
    </motion.div>
  );
  
  if (href) {
    return (
      <a href={href}>
        {ButtonContent}
      </a>
    );
  }
  
  return (
    <button onClick={onClick} type={type}>
      {ButtonContent}
    </button>
  );
}

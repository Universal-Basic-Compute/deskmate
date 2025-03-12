"use client";

import { motion } from 'framer-motion';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';
import Button from '../ui/Button';
import { useState } from 'react';
import ParticleEffect from '../ui/ParticleEffect';

export default function BetaProgram() {
  const [email, setEmail] = useState('');
  const [submitted, setSubmitted] = useState(false);
  const [showParticles, setShowParticles] = useState(false);
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Here you would typically send the email to your backend
    console.log('Submitted email:', email);
    setSubmitted(true);
    setShowParticles(true);
    
    // Reset form after 5 seconds
    setTimeout(() => {
      setSubmitted(false);
      setEmail('');
      setShowParticles(false);
    }, 5000);
  };

  return (
    <section id="beta" className="py-20 relative">
      <LightCone
        color="#FFD100"
        intensity={0.2}
        effect="breathing"
        className="absolute inset-0"
      >
        <div></div>
      </LightCone>
      
      <div className="container mx-auto px-4 relative z-10">
        <div className="max-w-4xl mx-auto bg-gray-900/70 backdrop-blur-md rounded-2xl p-8 md:p-12 relative overflow-hidden">
          <ParticleEffect trigger={showParticles} />
          
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
            className="text-center mb-8"
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Join Our <GradientText>Beta Program</GradientText>
            </h2>
            <p className="text-xl text-gray-300">
              Be among the first to experience DeskMate and help shape its future.
            </p>
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
          >
            {!submitted ? (
              <form onSubmit={handleSubmit} className="max-w-md mx-auto">
                <div className="flex flex-col md:flex-row gap-4">
                  <input
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="Enter your email"
                    required
                    className="flex-1 px-4 py-3 rounded-lg bg-gray-800 border border-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-yellow-400"
                  />
                  <Button type="submit" variant="primary">
                    Join Waitlist
                  </Button>
                </div>
                <p className="text-sm text-gray-400 mt-4 text-center">
                  We&apos;ll notify you when beta spots become available. No spam, ever.
                </p>
              </form>
            ) : (
              <div className="text-center py-8">
                <div className="text-5xl mb-4">🎉</div>
                <h3 className="text-2xl font-bold mb-2">Thank You!</h3>
                <p className="text-gray-300">
                  You&apos;ve been added to our waitlist. We&apos;ll be in touch soon!
                </p>
              </div>
            )}
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6, delay: 0.4 }}
            viewport={{ once: true }}
            className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6 text-center"
          >
            {[
              {
                title: "Early Access",
                description: "Be the first to try new features before they&apos;re released.",
                icon: "🚀"
              },
              {
                title: "Exclusive Pricing",
                description: "Beta testers receive special lifetime discounts.",
                icon: "💰"
              },
              {
                title: "Shape the Product",
                description: "Your feedback directly influences product development.",
                icon: "🔧"
              }
            ].map((item, index) => (
              <div key={index} className="p-4">
                <div className="text-4xl mb-4">{item.icon}</div>
                <h3 className="text-xl font-semibold mb-2">{item.title}</h3>
                <p className="text-gray-300">{item.description}</p>
              </div>
            ))}
          </motion.div>
        </div>
      </div>
    </section>
  );
}

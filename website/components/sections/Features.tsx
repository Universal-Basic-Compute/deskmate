"use client";

import { motion } from 'framer-motion';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';

export default function Features() {
  const features = [
    {
      title: "AI Study Assistant",
      description: "Ask questions about your study material and get guided explanations, not just answers.",
      icon: "🤖",
      color: "#FFD100"
    },
    {
      title: "Focus Monitoring",
      description: "Optional attention tracking with gentle reminders when your focus drifts.",
      icon: "👁️",
      color: "#FF9500"
    },
    {
      title: "Learning Style Adaptation",
      description: "Personalized study techniques based on your unique learning style.",
      icon: "🧠",
      color: "#9C27B0"
    },
    {
      title: "Session Analytics",
      description: "Track your study patterns and get insights to improve your productivity.",
      icon: "📊",
      color: "#4CAF50"
    },
    {
      title: "Pomodoro Timer",
      description: "Built-in study/break intervals to maximize focus and prevent burnout.",
      icon: "⏱️",
      color: "#2196F3"
    },
    {
      title: "Resource Suggestions",
      description: "Get recommendations for additional learning materials tailored to your needs.",
      icon: "📚",
      color: "#F44336"
    }
  ];

  return (
    <section id="features" className="py-20">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Powerful <GradientText>Features</GradientText>
            </h2>
            <p className="text-xl text-gray-300">
              DeskMate combines multiple technologies to create a comprehensive study companion.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              viewport={{ once: true }}
              className="bg-gray-900/50 backdrop-blur-sm rounded-xl p-6 relative overflow-hidden"
            >
              <LightCone
                color={feature.color}
                intensity={0.15}
                effect="breathing"
                className="absolute inset-0"
              >
                <div></div>
              </LightCone>
              <div className="relative z-10">
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold mb-3">{feature.title}</h3>
                <p className="text-gray-300">{feature.description}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}

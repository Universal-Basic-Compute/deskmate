"use client";

import { motion } from 'framer-motion';
import { useState } from 'react';
import GradientText from '../ui/GradientText';

type FAQItem = {
  question: string;
  answer: string;
};

export default function FAQ() {
  const [openIndex, setOpenIndex] = useState<number | null>(null);
  
  const faqs: FAQItem[] = [
    {
      question: "What makes DeskMate different from other AI tutors?",
      answer: "DeskMate combines physical presence (a smart lamp) with AI capabilities, creating a more immersive and focused study experience. Instead of just providing answers, DeskMate guides you through the learning process with a focus on understanding."
    },
    {
      question: "Do I need special hardware to use DeskMate?",
      answer: "For the full experience, you'll need the DeskMate smart lamp. However, we also offer a software-only version that works on your existing devices, though with more limited functionality."
    },
    {
      question: "How does the learning style adaptation work?",
      answer: "During onboarding, DeskMate assesses your learning preferences through a brief questionnaire. It then continuously refines its understanding by observing how you interact with content and which explanations resonate with you most."
    },
    {
      question: "Is my study data private and secure?",
      answer: "Absolutely. We take privacy seriously. Your study materials and conversations stay on your device when possible, and all data transmitted to our servers is encrypted. You can delete your data at any time."
    },
    {
      question: "Can DeskMate help with any subject?",
      answer: "DeskMate is designed to assist with most academic subjects, with particular strength in STEM fields, languages, and humanities. Its knowledge base is continuously expanding."
    },
    {
      question: "What if I want to cancel my subscription?",
      answer: "You can cancel your subscription at any time through your account settings. We offer a 30-day money-back guarantee for all paid plans."
    }
  ];

  const toggleQuestion = (index: number) => {
    setOpenIndex(openIndex === index ? null : index);
  };

  return (
    <section id="faq" className="py-20">
      <div className="container mx-auto px-4">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              Frequently Asked <GradientText>Questions</GradientText>
            </h2>
            <p className="text-xl text-gray-300">
              Everything you need to know about DeskMate.
            </p>
          </motion.div>
        </div>

        <div className="max-w-3xl mx-auto">
          {faqs.map((faq, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              viewport={{ once: true }}
              className="mb-6"
            >
              <button
                onClick={() => toggleQuestion(index)}
                className="flex justify-between items-center w-full text-left p-6 rounded-lg bg-gray-900/70 backdrop-blur-sm hover:bg-gray-800/70 transition-colors"
              >
                <h3 className="text-lg font-semibold pr-8">{faq.question}</h3>
                <span className="text-2xl">
                  {openIndex === index ? '−' : '+'}
                </span>
              </button>
              
              {openIndex === index && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3 }}
                  className="p-6 bg-gray-800/50 rounded-b-lg"
                >
                  <p className="text-gray-300">{faq.answer}</p>
                </motion.div>
              )}
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}

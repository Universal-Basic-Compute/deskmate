import { motion } from 'framer-motion';
import Image from 'next/image';
import LightCone from '../ui/LightCone';
import GradientText from '../ui/GradientText';

export default function About() {
  const team = [
    {
      name: "Nicolas Lester Reynolds",
      role: "Founder & CEO",
      bio: "Product-focused entrepreneur and engineer building at the intersection of AI, Web3, and community. Previously founded and scaled multiple successful projects including Civocracy (1M€+ raised) and gaming platforms with multi-million user bases.",
      image: "/images/team/nicolas.jpg"
    },
    {
      name: "Maya Patel",
      role: "Chief Product Officer",
      bio: "Educational psychologist specializing in personalized learning approaches.",
      image: "/images/team/maya.jpg"
    },
    {
      name: "David Kim",
      role: "CTO",
      bio: "AI engineer with expertise in natural language processing and computer vision.",
      image: "/images/team/david.jpg"
    }
  ];

  return (
    <section id="about" className="py-20 relative">
      <LightCone
        color="#9C27B0"
        intensity={0.1}
        effect="shifting"
        className="absolute inset-0"
      >
        <div></div>
      </LightCone>
      
      <div className="container mx-auto px-4 relative z-10">
        <div className="max-w-3xl mx-auto text-center mb-16">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h2 className="text-3xl md:text-4xl font-bold mb-6">
              About <GradientText>DeskMate</GradientText>
            </h2>
            <p className="text-xl text-gray-300">
              We're on a mission to transform how students learn and study.
            </p>
          </motion.div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center mb-20">
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
          >
            <h3 className="text-2xl font-bold mb-6">Our Story</h3>
            <p className="text-gray-300 mb-4">
              {`DeskMate was born from the experience of Nicolas Lester Reynolds at the intersection of AI, education, and community building. Having previously founded successful platforms that connected people and ideas, he saw an opportunity to transform how students learn.`}
            </p>
            <p className="text-gray-300 mb-4">
              With a background in building platforms that reached millions of users, Nicolas realized that what was missing in education was not more content, but better guidance—a companion that could understand individual learning styles and provide personalized support.
            </p>
            <p className="text-gray-300">
              By combining cutting-edge AI with the physical presence of a smart desk lamp, DeskMate was created: a study companion that transforms the solitary study experience into an interactive, guided session.
            </p>
          </motion.div>
          
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6, delay: 0.2 }}
            viewport={{ once: true }}
            className="relative"
          >
            <div className="absolute inset-0 bg-gradient-to-r from-violet-500/20 to-fuchsia-500/20 rounded-xl blur-xl" />
            <Image 
              src="/images/about-image.jpg" 
              alt="DeskMate Team" 
              width={800}
              height={500}
              className="relative z-10 rounded-xl shadow-2xl w-full"
            />
          </motion.div>
        </div>
        
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          viewport={{ once: true }}
          className="text-center mb-12"
        >
          <h3 className="text-2xl font-bold mb-6">Meet Our Team</h3>
        </motion.div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {team.map((member, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6, delay: index * 0.2 }}
              viewport={{ once: true }}
              className="bg-gray-900/50 backdrop-blur-sm rounded-xl overflow-hidden"
            >
              <div className="relative">
                <div className="absolute inset-0 bg-gradient-to-b from-transparent to-gray-900/90" />
                <Image 
                  src={member.image} 
                  alt={member.name}
                  width={400}
                  height={256}
                  className="w-full h-64 object-cover"
                />
                <div className="absolute bottom-0 left-0 right-0 p-6">
                  <h4 className="text-xl font-bold">{member.name}</h4>
                  <p className="text-violet-300">{member.role}</p>
                </div>
              </div>
              <div className="p-6">
                <p className="text-gray-300">{member.bio}</p>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}

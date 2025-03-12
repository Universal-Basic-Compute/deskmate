import Layout from '../components/Layout';
import GradientText from '../components/ui/GradientText';

export const metadata = {
  title: "Privacy Policy | DeskMate",
  description: "DeskMate's privacy policy explains how we collect, use, and protect your personal information."
};

export default function PrivacyPolicy() {
  return (
    <Layout>
        <div className="container mx-auto px-4 py-20">
          <h1 className="text-4xl font-bold mb-8">
            Privacy <GradientText>Policy</GradientText>
          </h1>
          
          <div className="prose prose-lg prose-invert max-w-none">
            <p>Last updated: {new Date().toLocaleDateString()}</p>
            
            <h2>1. Introduction</h2>
            <p>
              At DeskMate, we take your privacy seriously. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our website and services.
            </p>
            
            <h2>2. Information We Collect</h2>
            <p>
              We may collect personal information that you voluntarily provide to us when you express interest in obtaining information about us or our products and services, when you participate in activities on our services, or otherwise when you contact us.
            </p>
            
            <h2>3. How We Use Your Information</h2>
            <p>
              We use personal information collected via our services for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations.
            </p>
            
            <h2>4. Disclosure of Your Information</h2>
            <p>
              We may share information we have collected about you in certain situations. Your information may be disclosed as follows:
            </p>
            
            <h2>5. Security of Your Information</h2>
            <p>
              We use administrative, technical, and physical security measures to help protect your personal information. While we have taken reasonable steps to secure the personal information you provide to us, please be aware that despite our efforts, no security measures are perfect or impenetrable, and no method of data transmission can be guaranteed against any interception or other type of misuse.
            </p>
            
            <h2>6. Contact Us</h2>
            <p>
              If you have questions or comments about this Privacy Policy, please contact us at:
            </p>
            <p>
              Email: privacy@deskmate.ai<br />
              Address: 123 Learning Lane, Education City, CA 94000
            </p>
          </div>
        </div>
      </Layout>
  );
}

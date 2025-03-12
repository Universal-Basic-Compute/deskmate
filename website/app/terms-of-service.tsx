import Layout from '../components/Layout';
import GradientText from '../components/ui/GradientText';

export const metadata = {
  title: "Terms of Service | DeskMate",
  description: "DeskMate's terms of service outline the rules and guidelines for using our platform."
};

export default function TermsOfService() {
  return (
    <Layout>
        <div className="container mx-auto px-4 py-20">
          <h1 className="text-4xl font-bold mb-8">
            Terms of <GradientText>Service</GradientText>
          </h1>
          
          <div className="prose prose-lg prose-invert max-w-none">
            <p>Last updated: {new Date().toLocaleDateString()}</p>
            
            <h2>1. Agreement to Terms</h2>
            <p>
              By accessing or using DeskMate&apos;s website and services, you agree to be bound by these Terms of Service and all applicable laws and regulations. If you do not agree with any of these terms, you are prohibited from using or accessing this site.
            </p>
            
            <h2>2. Use License</h2>
            <p>
              Permission is granted to temporarily download one copy of the materials on DeskMate&apos;s website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.
            </p>
            
            <h2>3. Disclaimer</h2>
            <p>
              The materials on DeskMate&apos;s website are provided on an &apos;as is&apos; basis. DeskMate makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.
            </p>
            
            <h2>4. Limitations</h2>
            <p>
              In no event shall DeskMate or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on DeskMate&apos;s website, even if DeskMate or a DeskMate authorized representative has been notified orally or in writing of the possibility of such damage.
            </p>
            
            <h2>5. Revisions and Errata</h2>
            <p>
              The materials appearing on DeskMate&apos;s website could include technical, typographical, or photographic errors. DeskMate does not warrant that any of the materials on its website are accurate, complete or current. DeskMate may make changes to the materials contained on its website at any time without notice.
            </p>
            
            <h2>6. Contact Us</h2>
            <p>
              If you have any questions about these Terms, please contact us at:
            </p>
            <p>
              Email: legal@deskmate.ai<br />
              Address: 123 Learning Lane, Education City, CA 94000
            </p>
          </div>
        </div>
      </Layout>
  );
}

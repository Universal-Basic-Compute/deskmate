type GradientTextProps = {
  children: React.ReactNode;
  className?: string;
  from?: string;
  to?: string;
};

export default function GradientText({
  children,
  className = '',
  from = '#FFD100',
  to = '#FF9500',
}: GradientTextProps) {
  return (
    <span
      className={`bg-clip-text text-transparent bg-gradient-to-r ${className}`}
      style={{ backgroundImage: `linear-gradient(to right, ${from}, ${to})` }}
    >
      {children}
    </span>
  );
}

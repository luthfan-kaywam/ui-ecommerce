import React, { useState, useEffect } from 'react';

interface ConfettiPiece {
  id: number;
  left: number;
  color: string;
  size: number;
  duration: number;
  delay: number;
  isRound: boolean;
  rotation: number;
}

export default function App() {
  const [candlesBlown, setCandlesBlown] = useState<boolean>(false);
  const [letterOpen, setLetterOpen] = useState<boolean>(false);
  const [galleryIndex, setGalleryIndex] = useState<number>(0);
  const [confetti, setConfetti] = useState<ConfettiPiece[]>([]);

  // Confetti generator function
  const triggerConfetti = () => {
    const colors = ['#f97316', '#ec4899', '#a855f7', '#06b6d4', '#facc15', '#10b981'];
    const newPieces: ConfettiPiece[] = Array.from({ length: 90 }).map((_, i) => ({
      id: Date.now() + i + Math.random(),
      left: Math.random() * 100,
      color: colors[Math.floor(Math.random() * colors.length)],
      size: Math.floor(Math.random() * 9) + 6, // 6px - 14px
      duration: +(Math.random() * 2.5 + 2.5).toFixed(2), // 2.5s - 5s
      delay: +(Math.random() * 0.5).toFixed(2),
      isRound: Math.random() > 0.5,
      rotation: Math.floor(Math.random() * 360),
    }));

    setConfetti((prev) => [...prev, ...newPieces]);
  };

  // Trigger initial celebration confetti on load
  useEffect(() => {
    triggerConfetti();
  }, []);

  const galleryItems = [
    {
      id: 1,
      title: "Nongkrong Malam Komplek",
      subtitle: "Momen santai penuh kehangatan dan gelak tawa bersama sahabat komplek.",
      badge: "Kenangan 1",
      icon: "🌙",
      colorGradient: "from-pink-500/25 via-purple-600/20 to-indigo-700/25",
    },
    {
      id: 2,
      title: "Main Game & Turnamen Seru",
      subtitle: "Pertandingan game seru tiada tanding hingga larut malam.",
      badge: "Kenangan 2",
      icon: "🎮",
      colorGradient: "from-purple-500/25 via-indigo-600/20 to-blue-700/25",
    },
    {
      id: 3,
      title: "Petualangan & Jalan-Jalan",
      subtitle: "Jalan-jalan keliling kota dan petualangan yang tak terlupakan.",
      badge: "Kenangan 3",
      icon: "🚲",
      colorGradient: "from-cyan-500/25 via-teal-600/20 to-emerald-700/25",
    },
    {
      id: 4,
      title: "Pesta Ulang Tahun Meriah",
      subtitle: "Merayakan momen bertambahnya usia dengan kebahagiaan penuh kejutan.",
      badge: "Kenangan 4",
      icon: "🎂",
      colorGradient: "from-amber-500/25 via-orange-600/20 to-red-700/25",
    },
    {
      id: 5,
      title: "Teman Komplek Selamanya",
      subtitle: "Persahabatan sejati Deka Nazilil Ramadhan & Teman Komplek yang tak pernah pudar.",
      badge: "Kenangan 5",
      icon: "⭐",
      colorGradient: "from-rose-500/25 via-pink-600/20 to-purple-700/25",
    },
  ];

  const handleNextGallery = () => {
    setGalleryIndex((prev) => (prev + 1) % galleryItems.length);
  };

  const handlePrevGallery = () => {
    setGalleryIndex((prev) => (prev - 1 + galleryItems.length) % galleryItems.length);
  };

  const handleCakeClick = () => {
    setCandlesBlown(!candlesBlown);
    triggerConfetti();
  };

  return (
    <div className="relative min-h-screen overflow-x-hidden selection:bg-pink-500 selection:text-white">
      {/* Confetti Container */}
      <div className="fixed inset-0 pointer-events-none z-[80] overflow-hidden">
        {confetti.map((item) => (
          <div
            key={item.id}
            className="confetti-piece shadow-sm"
            style={{
              left: `${item.left}%`,
              width: `${item.size}px`,
              height: `${item.size}px`,
              backgroundColor: item.color,
              borderRadius: item.isRound ? '50%' : '2px',
              animationDuration: `${item.duration}s`,
              animationDelay: `${item.delay}s`,
              boxShadow: `0 0 8px ${item.color}`,
            }}
          />
        ))}
      </div>

      {/* Floating RAYAKAN Button */}
      <button
        onClick={triggerConfetti}
        className="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 bg-gradient-to-r from-[#ec4899] via-[#a855f7] to-[#06b6d4] px-6 py-3.5 rounded-full font-fredoka text-white font-bold text-base sm:text-lg border border-white/30 animate-pulse-glow hover:scale-105 active:scale-95 transition-all duration-300 flex items-center gap-2.5 shadow-2xl cursor-pointer"
        aria-label="Rayakan Bersama"
      >
        <span className="text-xl">🎉</span>
        <span>RAYAKAN BERSAMA!</span>
        <span className="text-xl">🎉</span>
      </button>

      {/* HERO SECTION */}
      <header className="relative min-h-screen flex flex-col items-center justify-center pt-12 pb-20 px-4 text-center overflow-hidden">
        {/* Floating Gradient Orbs inside Hero */}
        <div
          className="absolute pointer-events-none overflow-hidden animate-orb"
          style={{
            top: '-60px',
            left: '-60px',
            width: '380px',
            height: '380px',
            background: 'radial-gradient(circle, #a855f7 0%, #ec4899 100%)',
            opacity: 0.25,
            borderRadius: '9999px',
            filter: 'blur(50px)',
          }}
        />
        <div
          className="absolute pointer-events-none overflow-hidden animate-orb"
          style={{
            top: '40px',
            right: '-40px',
            width: '320px',
            height: '320px',
            background: 'radial-gradient(circle, #06b6d4 0%, #a855f7 100%)',
            opacity: 0.22,
            borderRadius: '9999px',
            filter: 'blur(50px)',
            animationDelay: '-3s',
          }}
        />

        {/* 6 Scattered SVG Star Sparkles */}
        <svg
          className="absolute top-16 left-[12%] w-7 h-7 text-pink-300 animate-sparkle"
          style={{ animationDelay: '0s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z" />
        </svg>
        <svg
          className="absolute top-28 right-[15%] w-9 h-9 text-amber-300 animate-sparkle"
          style={{ animationDelay: '0.4s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 9.41L0 12L9.41 9.41L12 0Z" />
        </svg>
        <svg
          className="absolute bottom-40 left-[8%] w-8 h-8 text-cyan-300 animate-sparkle"
          style={{ animationDelay: '0.8s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 9.41L0 12L9.41 9.41L12 0Z" />
        </svg>
        <svg
          className="absolute bottom-32 right-[10%] w-7 h-7 text-purple-300 animate-sparkle"
          style={{ animationDelay: '1.2s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 9.41L0 12L9.41 9.41L12 0Z" />
        </svg>
        <svg
          className="absolute top-1/2 left-[5%] w-6 h-6 text-emerald-300 animate-sparkle"
          style={{ animationDelay: '1.6s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z" />
        </svg>
        <svg
          className="absolute top-1/3 right-[6%] w-8 h-8 text-pink-400 animate-sparkle"
          style={{ animationDelay: '2.0s' }}
          viewBox="0 0 24 24"
          fill="currentColor"
        >
          <path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 9.41L0 12L9.41 9.41L12 0Z" />
        </svg>

        {/* Content Container */}
        <div className="relative z-10 max-w-4xl mx-auto flex flex-col items-center">
          {/* Pill Badges */}
          <div className="flex flex-wrap justify-center items-center gap-3 mb-6">
            <span
              className="px-4 py-1.5 rounded-full font-bold text-xs sm:text-sm bg-orange-500/20 border border-orange-500/50 text-orange-300 backdrop-blur-md"
              style={{ boxShadow: '0 0 16px rgba(249, 115, 22, 0.5)' }}
            >
              PESTA 🎉
            </span>
            <span
              className="px-4 py-1.5 rounded-full font-bold text-xs sm:text-sm bg-cyan-500/20 border border-cyan-500/50 text-cyan-300 backdrop-blur-md"
              style={{ boxShadow: '0 0 16px rgba(6, 182, 212, 0.5)' }}
            >
              Hai Deka! 👋
            </span>
            <span
              className="px-4 py-1.5 rounded-full font-bold text-xs sm:text-sm bg-pink-500/20 border border-pink-500/50 text-pink-300 backdrop-blur-md"
              style={{ boxShadow: '0 0 16px rgba(236, 72, 153, 0.5)' }}
            >
              ULANG TAHUN 🎂
            </span>
            <span
              className="px-4 py-1.5 rounded-full font-bold text-xs sm:text-sm bg-yellow-500/20 border border-yellow-500/50 text-yellow-300 backdrop-blur-md"
              style={{ boxShadow: '0 0 16px rgba(250, 204, 21, 0.5)' }}
            >
              HOREEE 🥳
            </span>
          </div>

          {/* Heading */}
          <h1
            className="font-fredoka text-5xl sm:text-7xl md:text-8xl lg:text-[85px] text-white leading-tight font-black tracking-tight"
            style={{ textShadow: '0 0 60px rgba(236,72,153,0.5)' }}
          >
            HAPPY BIRTHDAY, BRO!
          </h1>

          {/* Name */}
          <div className="my-3">
            <h2 className="shimmer-text font-fredoka text-3xl sm:text-5xl md:text-6xl lg:text-[56px] font-extrabold tracking-wide">
              Deka Nazilil Ramadhan
            </h2>
          </div>

          {/* Subtitle */}
          <p className="text-white/65 font-bold tracking-widest uppercase text-base sm:text-lg md:text-xl mt-2 mb-10">
            Teman Komplek ∞ Selamanya
          </p>

          {/* Info Cards */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 sm:gap-6 w-full max-w-3xl mt-4">
            <div className="glass-card rounded-2xl p-5 relative overflow-hidden transition-transform duration-300 hover:scale-105 border border-white/20 shadow-lg text-center group">
              <div className="absolute inset-0 bg-gradient-to-br from-pink-500/20 to-purple-600/20 opacity-15 pointer-events-none" />
              <div className="text-3xl mb-2">📅</div>
              <div className="text-xs uppercase tracking-widest text-pink-300 font-bold">Tanggal</div>
              <div className="font-fredoka text-xl text-white font-bold mt-1">13 Agustus</div>
            </div>

            <div className="glass-card rounded-2xl p-5 relative overflow-hidden transition-transform duration-300 hover:scale-105 border border-white/20 shadow-lg text-center group">
              <div className="absolute inset-0 bg-gradient-to-br from-purple-500/20 to-indigo-600/20 opacity-15 pointer-events-none" />
              <div className="text-3xl mb-2">🎉</div>
              <div className="text-xs uppercase tracking-widest text-purple-300 font-bold">Hari Istimewa</div>
              <div className="font-fredoka text-xl text-white font-bold mt-1">Ulang Tahun Deka</div>
            </div>

            <div className="glass-card rounded-2xl p-5 relative overflow-hidden transition-transform duration-300 hover:scale-105 border border-white/20 shadow-lg text-center group">
              <div className="absolute inset-0 bg-gradient-to-br from-cyan-500/20 to-teal-600/20 opacity-15 pointer-events-none" />
              <div className="text-3xl mb-2">🤝</div>
              <div className="text-xs uppercase tracking-widest text-cyan-300 font-bold">Teman Komplek</div>
              <div className="font-fredoka text-xl text-white font-bold mt-1">Solid Sejak Dulu</div>
            </div>
          </div>

          {/* INTERACTIVE BIRTHDAY CAKE */}
          <div className="mt-14 flex flex-col items-center">
            <div
              onClick={handleCakeClick}
              className="relative cursor-pointer group flex flex-col items-center select-none"
              title="Klik untuk tiup / nyalakan lilin!"
            >
              {/* Candles Container */}
              <div className="flex justify-center items-end gap-6 mb-0 z-20">
                {/* Candle 1 (Pink) */}
                <div className="relative flex flex-col items-center">
                  {!candlesBlown ? (
                    <div
                      className="w-4 h-7 mb-1 rounded-full animate-flame transition-opacity duration-300"
                      style={{
                        background: 'radial-gradient(circle, #facc15 20%, #f97316 70%, transparent 100%)',
                        filter: 'blur(1px)',
                        boxShadow: '0 0 14px #f97316, 0 0 25px #facc15',
                      }}
                    />
                  ) : (
                    <div className="w-1.5 h-3 mb-1 bg-white/40 rounded-full blur-[1px]" />
                  )}
                  <div className="w-3 h-10 bg-gradient-to-b from-pink-400 to-pink-600 rounded-t-sm shadow-md border-t border-white/40" />
                </div>

                {/* Candle 2 (Purple) */}
                <div className="relative flex flex-col items-center">
                  {!candlesBlown ? (
                    <div
                      className="w-4 h-7 mb-1 rounded-full animate-flame transition-opacity duration-300"
                      style={{
                        background: 'radial-gradient(circle, #facc15 20%, #f97316 70%, transparent 100%)',
                        filter: 'blur(1px)',
                        boxShadow: '0 0 14px #f97316, 0 0 25px #facc15',
                        animationDelay: '0.2s',
                      }}
                    />
                  ) : (
                    <div className="w-1.5 h-3 mb-1 bg-white/40 rounded-full blur-[1px]" />
                  )}
                  <div className="w-3.5 h-12 bg-gradient-to-b from-purple-400 to-purple-600 rounded-t-sm shadow-md border-t border-white/40" />
                </div>

                {/* Candle 3 (Teal) */}
                <div className="relative flex flex-col items-center">
                  {!candlesBlown ? (
                    <div
                      className="w-4 h-7 mb-1 rounded-full animate-flame transition-opacity duration-300"
                      style={{
                        background: 'radial-gradient(circle, #facc15 20%, #f97316 70%, transparent 100%)',
                        filter: 'blur(1px)',
                        boxShadow: '0 0 14px #f97316, 0 0 25px #facc15',
                        animationDelay: '0.4s',
                      }}
                    />
                  ) : (
                    <div className="w-1.5 h-3 mb-1 bg-white/40 rounded-full blur-[1px]" />
                  )}
                  <div className="w-3 h-10 bg-gradient-to-b from-cyan-400 to-cyan-600 rounded-t-sm shadow-md border-t border-white/40" />
                </div>
              </div>

              {/* Tier 1 (Top Tier) */}
              <div className="relative w-36 h-14 bg-gradient-to-r from-[#06b6d4] to-[#a855f7] rounded-t-2xl shadow-lg border-t border-white/30 flex items-center justify-center z-15">
                {/* White Frosting Drip */}
                <div className="absolute -bottom-2 left-0 right-0 h-4 bg-white/90 rounded-b-full shadow-inner flex justify-around items-center px-1">
                  <span className="w-3 h-3 bg-white/90 rounded-full -mt-1" />
                  <span className="w-4 h-4 bg-white/90 rounded-full" />
                  <span className="w-3 h-3 bg-white/90 rounded-full -mt-1" />
                  <span className="w-4 h-4 bg-white/90 rounded-full" />
                </div>
              </div>

              {/* Tier 2 (Middle Tier) */}
              <div className="relative w-48 h-18 bg-gradient-to-r from-[#facc15] to-[#f97316] shadow-lg flex items-center justify-center z-10 border-t border-white/20">
                <span className="font-fredoka text-white text-base sm:text-lg font-bold tracking-wider drop-shadow-md">
                  HAPPY B'DAY
                </span>
                {/* White Frosting Drip */}
                <div className="absolute -bottom-2 left-0 right-0 h-4 bg-white/90 rounded-b-full shadow-inner flex justify-around items-center px-1">
                  <span className="w-4 h-4 bg-white/90 rounded-full" />
                  <span className="w-3 h-3 bg-white/90 rounded-full -mt-1" />
                  <span className="w-5 h-5 bg-white/90 rounded-full" />
                  <span className="w-3 h-3 bg-white/90 rounded-full -mt-1" />
                  <span className="w-4 h-4 bg-white/90 rounded-full" />
                </div>
              </div>

              {/* Tier 3 (Bottom Tier) */}
              <div className="relative w-64 h-22 bg-gradient-to-r from-[#ec4899] to-[#f43f5e] rounded-b-2xl shadow-2xl flex items-center justify-center z-5 border-t border-white/20">
                {/* Decorative Sprinkles */}
                <div className="flex gap-4">
                  <span className="w-2.5 h-2.5 rounded-full bg-yellow-300 opacity-80 shadow" />
                  <span className="w-2.5 h-2.5 rounded-full bg-cyan-300 opacity-80 shadow" />
                  <span className="w-2.5 h-2.5 rounded-full bg-purple-300 opacity-80 shadow" />
                  <span className="w-2.5 h-2.5 rounded-full bg-white opacity-80 shadow" />
                  <span className="w-2.5 h-2.5 rounded-full bg-yellow-300 opacity-80 shadow" />
                </div>
              </div>
            </div>

            {/* Cake Helper Button */}
            <button
              onClick={handleCakeClick}
              className="mt-6 px-5 py-2 rounded-full text-xs sm:text-sm font-bold bg-white/10 hover:bg-white/20 border border-white/25 text-white/90 transition-all flex items-center gap-2 shadow-md cursor-pointer"
            >
              <span>{candlesBlown ? '🔥 Nyalakan Lilin Lagi' : '💨 Tiup Lilin Ulang Tahun'}</span>
            </button>
          </div>
        </div>
      </header>

      {/* TIMELINE PERTEMANAN SECTION */}
      <section className="relative py-24 px-4 max-w-5xl mx-auto overflow-hidden">
        {/* Floating Gradient Orb Mid-Right */}
        <div
          className="absolute pointer-events-none overflow-hidden animate-orb"
          style={{
            top: '20%',
            right: '2%',
            width: '200px',
            height: '200px',
            background: 'radial-gradient(circle, #facc15 0%, #f97316 100%)',
            opacity: 0.18,
            borderRadius: '9999px',
            filter: 'blur(40px)',
          }}
        />

        {/* Header */}
        <div className="text-center mb-16 relative z-10">
          <div className="inline-block px-4 py-1.5 rounded-full text-xs font-bold bg-pink-500/20 border border-pink-500/40 text-pink-300 mb-3 shadow-md">
            MOMEN BERKESAN
          </div>
          <h2 className="font-fredoka text-3xl sm:text-5xl text-transparent bg-clip-text bg-gradient-to-r from-orange-400 via-pink-500 to-purple-400 font-extrabold tracking-tight">
            Timeline Pertemanan Kita
          </h2>
          <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2 max-w-xl mx-auto">
            Kilas balik perjalanan persahabatan yang penuh kenangan tak terlupakan.
          </p>
        </div>

        {/* Timeline Container */}
        <div className="relative z-10">
          {/* Vertical Gradient Line */}
          <div
            className="absolute top-0 bottom-0 left-6 sm:left-1/2 sm:-translate-x-1/2 w-1.5 rounded-full"
            style={{
              background: 'linear-gradient(180deg, #ec4899 0%, #a855f7 50%, #06b6d4 100%)',
            }}
          />

          {/* Timeline Cards List */}
          <div className="space-y-12">
            {/* Item 1 */}
            <div className="relative flex flex-col sm:flex-row items-center">
              {/* Dot */}
              <div
                className="absolute left-6 sm:left-1/2 -translate-x-1/2 w-5 h-5 rounded-full bg-pink-500 border-2 border-white z-20"
                style={{ boxShadow: '0 0 18px rgba(236,72,153,0.9)' }}
              />
              <div className="w-full sm:w-1/2 pl-14 sm:pl-0 sm:pr-12 text-left sm:text-right">
                <div className="glass-card rounded-2xl p-6 transition-all duration-300 hover:scale-[1.02] shadow-xl border border-white/20">
                  <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-orange-500/20 text-orange-300 border border-orange-500/40 mb-2">
                    Awal Pertemuan
                  </span>
                  <h3 className="font-fredoka text-xl sm:text-2xl text-white font-black">
                    Awal Kenal di Komplek
                  </h3>
                  <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2">
                    Pertama kali kenal di komplek rumah, main bareng tiap sore sampai dipanggil pulang oleh orang tua.
                  </p>
                </div>
              </div>
            </div>

            {/* Item 2 */}
            <div className="relative flex flex-col sm:flex-row-reverse items-center">
              {/* Dot */}
              <div
                className="absolute left-6 sm:left-1/2 -translate-x-1/2 w-5 h-5 rounded-full bg-purple-500 border-2 border-white z-20"
                style={{ boxShadow: '0 0 18px rgba(168,85,247,0.9)' }}
              />
              <div className="w-full sm:w-1/2 pl-14 sm:pl-0 sm:pl-12 text-left">
                <div className="glass-card rounded-2xl p-6 transition-all duration-300 hover:scale-[1.02] shadow-xl border border-white/20">
                  <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-purple-500/20 text-purple-300 border border-purple-500/40 mb-2">
                    Nongkrong Seru
                  </span>
                  <h3 className="font-fredoka text-xl sm:text-2xl text-white font-black">
                    Masa Nongkrong & Game
                  </h3>
                  <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2">
                    Masa-masa seru nongkrong di gardu, main game bareng, ketawa tanpa beban, dan cerita sampai malam.
                  </p>
                </div>
              </div>
            </div>

            {/* Item 3 */}
            <div className="relative flex flex-col sm:flex-row items-center">
              {/* Dot */}
              <div
                className="absolute left-6 sm:left-1/2 -translate-x-1/2 w-5 h-5 rounded-full bg-cyan-500 border-2 border-white z-20"
                style={{ boxShadow: '0 0 18px rgba(6,182,212,0.9)' }}
              />
              <div className="w-full sm:w-1/2 pl-14 sm:pl-0 sm:pr-12 text-left sm:text-right">
                <div className="glass-card rounded-2xl p-6 transition-all duration-300 hover:scale-[1.02] shadow-xl border border-white/20">
                  <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-cyan-500/20 text-cyan-300 border border-cyan-500/40 mb-2">
                    Kebersamaan
                  </span>
                  <h3 className="font-fredoka text-xl sm:text-2xl text-white font-black">
                    Suka & Duka Bersama
                  </h3>
                  <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2">
                    Banyak cerita seru yang udah kita lewati bareng, dari kejadian konyol sampai saling dukung satu sama lain.
                  </p>
                </div>
              </div>
            </div>

            {/* Item 4 */}
            <div className="relative flex flex-col sm:flex-row-reverse items-center">
              {/* Dot */}
              <div
                className="absolute left-6 sm:left-1/2 -translate-x-1/2 w-5 h-5 rounded-full bg-yellow-400 border-2 border-white z-20"
                style={{ boxShadow: '0 0 18px rgba(250,204,21,0.9)' }}
              />
              <div className="w-full sm:w-1/2 pl-14 sm:pl-0 sm:pl-12 text-left">
                <div className="glass-card rounded-2xl p-6 transition-all duration-300 hover:scale-[1.02] shadow-xl border border-white/20">
                  <span className="inline-block px-3 py-1 rounded-full text-xs font-bold bg-yellow-500/20 text-yellow-300 border border-yellow-500/40 mb-2">
                    Hingga Kini
                  </span>
                  <h3 className="font-fredoka text-xl sm:text-2xl text-white font-black">
                    Solid Sampai Kapanpun
                  </h3>
                  <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2">
                    Meskipun makin sibuk dengan urusan masing-masing, persahabatan kita tetap erat, solid, dan selalu ada!
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* GALERI KENANGAN CAROUSEL SECTION */}
      <section className="relative py-24 px-4 max-w-5xl mx-auto overflow-hidden">
        {/* Header */}
        <div className="text-center mb-14 relative z-10">
          <div className="inline-block px-4 py-1.5 rounded-full text-xs font-bold bg-cyan-500/20 border border-cyan-500/40 text-cyan-300 mb-3 shadow-md">
            GALERI FOTO
          </div>
          <h2 className="font-fredoka text-3xl sm:text-5xl text-transparent bg-clip-text bg-gradient-to-r from-pink-400 via-purple-400 to-cyan-400 font-extrabold tracking-tight">
            Galeri Kenangan
          </h2>
          <p className="font-nunito text-white/70 text-sm sm:text-base font-semibold mt-2">
            Geser untuk melihat momen-momen berkesan pertemanan komplek.
          </p>
        </div>

        {/* 3D Stack Carousel */}
        <div className="relative z-10 flex flex-col items-center">
          <div className="relative w-full max-w-md h-[340px] flex items-center justify-center my-6">
            {galleryItems.map((item, idx) => {
              const total = galleryItems.length;
              let diff = (idx - galleryIndex + total) % total;
              if (diff > total / 2) diff -= total;

              // Active card
              if (diff === 0) {
                return (
                  <div
                    key={item.id}
                    className="absolute inset-0 glass-card rounded-3xl p-6 sm:p-8 flex flex-col justify-between transition-all duration-500 ease-out z-10 scale-100 opacity-100 border border-white/30 shadow-[0_24px_60px_rgba(0,0,0,0.4)] overflow-hidden"
                  >
                    <div className={`absolute inset-0 bg-gradient-to-br ${item.colorGradient} pointer-events-none`} />
                    <div className="relative z-10 flex justify-between items-start">
                      <span className="px-3 py-1 rounded-full text-xs font-bold bg-white/15 border border-white/25 text-white">
                        {item.badge}
                      </span>
                      <span className="text-4xl">{item.icon}</span>
                    </div>

                    <div className="relative z-10 my-auto text-center py-4">
                      <div className="text-5xl mb-3">{item.icon}</div>
                      <h3 className="font-fredoka text-2xl sm:text-3xl text-white font-black">
                        {item.title}
                      </h3>
                      <p className="font-nunito text-white/80 font-semibold text-sm sm:text-base mt-2">
                        {item.subtitle}
                      </p>
                    </div>

                    <div className="relative z-10 text-xs text-white/50 font-bold uppercase tracking-widest text-center">
                      Deka Nazilil Ramadhan
                    </div>
                  </div>
                );
              }

              // Left side card (-1)
              if (diff === -1 || diff === total - 1) {
                return (
                  <div
                    key={item.id}
                    className="absolute inset-0 glass-card rounded-3xl p-6 flex flex-col justify-between transition-all duration-500 ease-out z-0 scale-85 opacity-45 -rotate-6 -translate-x-14 sm:-translate-x-[70px] border border-white/20 pointer-events-none overflow-hidden select-none"
                  >
                    <div className={`absolute inset-0 bg-gradient-to-br ${item.colorGradient}`} />
                    <div className="text-3xl">{item.icon}</div>
                    <h3 className="font-fredoka text-xl text-white opacity-80">{item.title}</h3>
                  </div>
                );
              }

              // Right side card (+1)
              if (diff === 1 || diff === -(total - 1)) {
                return (
                  <div
                    key={item.id}
                    className="absolute inset-0 glass-card rounded-3xl p-6 flex flex-col justify-between transition-all duration-500 ease-out z-0 scale-85 opacity-45 rotate-6 translate-x-14 sm:translate-x-[70px] border border-white/20 pointer-events-none overflow-hidden select-none"
                  >
                    <div className={`absolute inset-0 bg-gradient-to-br ${item.colorGradient}`} />
                    <div className="text-3xl text-right">{item.icon}</div>
                    <h3 className="font-fredoka text-xl text-white opacity-80">{item.title}</h3>
                  </div>
                );
              }

              return null;
            })}
          </div>

          {/* Controls & Indicators */}
          <div className="flex items-center gap-6 mt-8">
            <button
              onClick={handlePrevGallery}
              className="glass-card rounded-full w-[44px] h-[44px] flex items-center justify-center text-white hover:bg-white/20 active:scale-95 transition-all shadow-lg cursor-pointer font-bold text-lg"
              aria-label="Previous image"
            >
              ←
            </button>

            {/* Dots */}
            <div className="flex items-center gap-2">
              {galleryItems.map((_, idx) => (
                <button
                  key={idx}
                  onClick={() => setGalleryIndex(idx)}
                  className={`transition-all duration-300 cursor-pointer ${
                    idx === galleryIndex
                      ? 'w-6 h-2 rounded-full bg-[#ec4899] shadow-[0_0_10px_#ec4899]'
                      : 'w-2 h-2 rounded-full bg-white/30 hover:bg-white/60'
                  }`}
                  aria-label={`Go to slide ${idx + 1}`}
                />
              ))}
            </div>

            <button
              onClick={handleNextGallery}
              className="glass-card rounded-full w-[44px] h-[44px] flex items-center justify-center text-white hover:bg-white/20 active:scale-95 transition-all shadow-lg cursor-pointer font-bold text-lg"
              aria-label="Next image"
            >
              →
            </button>
          </div>
        </div>
      </section>

      {/* SURAT SPESIAL SECTION */}
      <section className="relative py-20 px-4 max-w-3xl mx-auto overflow-hidden">
        {/* Floating Gradient Orb Bottom-Center */}
        <div
          className="absolute pointer-events-none overflow-hidden animate-orb"
          style={{
            bottom: '10%',
            left: '50%',
            transform: 'translateX(-50%)',
            width: '280px',
            height: '280px',
            background: 'radial-gradient(circle, #ec4899 0%, #f97316 100%)',
            opacity: 0.2,
            borderRadius: '9999px',
            filter: 'blur(45px)',
          }}
        />

        <div className="relative z-10">
          <div
            onClick={() => setLetterOpen(true)}
            className="glass-card rounded-2xl p-6 flex flex-col sm:flex-row items-center gap-6 cursor-pointer hover:bg-white/10 transition-all duration-300 border border-white/20 shadow-2xl group"
          >
            {/* Icon Box Left */}
            <div
              className="w-16 h-16 rounded-2xl flex items-center justify-center text-3xl bg-gradient-to-br from-[#ec4899] to-[#a855f7] flex-shrink-0 transition-transform group-hover:scale-110 duration-300"
              style={{ boxShadow: '0 0 22px rgba(236,72,153,0.6)' }}
            >
              {letterOpen ? '📖' : '💌'}
            </div>

            {/* Text */}
            <div className="text-center sm:text-left flex-1">
              <h3 className="font-fredoka text-2xl text-white font-bold group-hover:text-pink-300 transition-colors">
                Surat Spesial untuk Deka
              </h3>
              <p className="font-nunito text-white/70 font-semibold text-sm sm:text-base mt-1">
                Klik di sini untuk membuka & membaca pesan ucapan persahabatan 💌
              </p>
            </div>

            <div className="px-4 py-2 rounded-full text-xs font-bold bg-pink-500/20 text-pink-300 border border-pink-500/40 group-hover:bg-pink-500/30 transition-all">
              Buka Surat ✨
            </div>
          </div>
        </div>
      </section>

      {/* LETTER MODAL OVERLAY */}
      {letterOpen && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/65 backdrop-blur-md transition-opacity">
          <div className="glass-card bg-[#250d47]/95 border border-white/25 rounded-3xl p-8 max-w-md w-full relative shadow-2xl animate-bounce-in text-center">
            {/* Close Button Top Right */}
            <button
              onClick={() => setLetterOpen(false)}
              className="absolute top-4 right-4 w-9 h-9 rounded-full bg-white/10 hover:bg-white/25 flex items-center justify-center text-white font-bold transition-all cursor-pointer"
              aria-label="Tutup Modal"
            >
              ✕
            </button>

            {/* Icon Badge */}
            <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-pink-500 to-purple-600 flex items-center justify-center text-3xl shadow-lg mx-auto mb-4 border border-white/30">
              📖
            </div>

            {/* Title */}
            <h3 className="font-fredoka text-2xl sm:text-3xl text-transparent bg-clip-text bg-gradient-to-r from-pink-300 via-purple-200 to-cyan-300 mb-4 font-bold">
              Surat Ulang Tahun 💌
            </h3>

            {/* Message Body */}
            <div className="font-nunito text-white/85 text-sm sm:text-base font-semibold leading-relaxed text-left space-y-3 my-4 bg-white/5 p-5 rounded-2xl border border-white/10">
              <p>
                Selamat Ulang Tahun, <strong className="text-pink-300 font-bold">Deka Nazilil Ramadhan</strong>! 🎉
              </p>
              <p>
                Semoga di usiamu yang baru ini, kamu selalu diberikan kesehatan, kebahagiaan, kelancaran dalam setiap langkah, dan rezeki yang berlimpah.
              </p>
              <p>
                Terima kasih sudah menjadi teman komplek yang selalu seru, solid, dan selalu ada. Semoga persahabatan kita tetap langgeng & erat sampai kapanpun!
              </p>
              <p className="text-pink-200">
                Tetap jadi pribadi yang baik dan menginspirasi! Cheers untuk tahun yang luar biasa! 🥂✨
              </p>
            </div>

            {/* Action Button */}
            <button
              onClick={() => setLetterOpen(false)}
              className="w-full mt-2 py-3 rounded-2xl font-fredoka text-white font-bold bg-gradient-to-r from-pink-500 to-purple-600 hover:from-pink-600 hover:to-purple-700 shadow-lg border border-white/20 transition-all cursor-pointer"
            >
              Tutup Surat 💌
            </button>
          </div>
        </div>
      )}

      {/* FOOTER */}
      <footer
        className="relative pt-16 pb-24 overflow-hidden text-center"
        style={{
          background: 'linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.5) 100%)',
        }}
      >
        <div className="relative z-10 max-w-xl mx-auto px-4 flex flex-col items-center">
          {/* Animated Floating Cake Emoji */}
          <div className="text-5xl sm:text-6xl mb-4 inline-block animate-float-cake">
            🎂
          </div>

          {/* Heading */}
          <h3
            className="font-fredoka text-2xl sm:text-4xl text-white font-bold tracking-tight mb-3"
            style={{ textShadow: '0 0 25px rgba(236,72,153,0.6)' }}
          >
            HAPPY BIRTHDAY DEKA NAZILIL RAMADHAN!
          </h3>

          {/* Gradient Divider Line */}
          <div
            className="w-48 sm:w-64 h-[1px] my-6"
            style={{
              background: 'linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.35) 50%, transparent 100%)',
            }}
          />

          {/* Subtitle */}
          <p className="font-nunito text-white/70 font-semibold text-sm sm:text-base">
            Dibuat dengan ❤️ untuk Deka Nazilil Ramadhan — Teman Komplek Selamanya
          </p>
        </div>
      </footer>
    </div>
  );
}

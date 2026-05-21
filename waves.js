const canvas = document.getElementById('wave-canvas');
const ctx = canvas.getContext('2d');

// Track viewport size dynamically
function resizeCanvas() {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
}
window.addEventListener('resize', resizeCanvas);
resizeCanvas();

// 5 distinct sine waves
const waves = [
  { yRatio: 0.15, amplitude: 25, frequency: 0.005, speed: 0.003, phase: 0 },
  { yRatio: 0.32, amplitude: 35, frequency: 0.003, speed: -0.002, phase: 2 },
  { yRatio: 0.50, amplitude: 20, frequency: 0.006, speed: 0.004, phase: 4 },
  { yRatio: 0.68, amplitude: 40, frequency: 0.002, speed: -0.0035, phase: 1 },
  { yRatio: 0.85, amplitude: 30, frequency: 0.004, speed: 0.0045, phase: 5 }
];

const waveColors = [
  'rgba(226, 162, 128, 0.25)',  /* Stronger peach accent */
  'rgba(180, 100, 100, 0.35)',  /* Richer burgundy tone */
  'rgba(200, 150, 150, 0.20)',  /* Visible dusty-rose */
  'rgba(226, 162, 128, 0.20)',  /* Soft peach highlight */
  'rgba(150, 80, 80, 0.40)'     /* Deeper, more saturated line */
];

function animate() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  waves.forEach((wave, index) => {
    ctx.beginPath();
    
    const baseHeight = canvas.height * wave.yRatio;

    for (let x = 0; x < canvas.width; x++) {
      const y = baseHeight + Math.sin(x * wave.frequency + wave.phase) * wave.amplitude;
      
      if (x === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    }

    ctx.strokeStyle = waveColors[index % waveColors.length];
    ctx.lineWidth = 2.5;
    ctx.stroke();

    wave.phase += wave.speed;
  });

  requestAnimationFrame(animate);
}

animate();
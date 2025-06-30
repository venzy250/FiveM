window.addEventListener("message", function (event) {
  const data = event.data;

  if (data.type === "updateOverlay") {
    document.getElementById("bodycam-ui").style.display = data.visible ? "block" : "none";

    if (data.visible) {
      document.getElementById("unit").innerText = "UNIT: " + data.unit;
      document.getElementById("district").innerText = "DISTRICT: " + data.district;
      document.getElementById("time").innerText = "UTC: " + data.time;
      document.getElementById("evidence").innerText = "EVIDENCE ID: " + data.evidence;
      document.getElementById("shift").innerText = "SHIFT: " + data.shift;
      document.getElementById("battery").innerText = "BATTERY: " + data.battery + "%";
    }
  }

  if (data.type === "voice") {
    const mic = document.getElementById("mic");
    mic.className = data.active ? "mic-on" : "mic-off";
  }

  if (data.type === "playSound") {
    const audio = new Audio(`./sounds/${data.file}`);
    audio.volume = 0.5;
    audio.play();
  }
});

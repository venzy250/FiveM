let currentTab = "view";
let currentPage = 1;
let allEvidence = [];
let selectedEvidence = null;

function switchTab(tab) {
  document.querySelectorAll(".tab-content").forEach(div => div.style.display = "none");
  document.getElementById(tab).style.display = "block";
  currentTab = tab;
}

function closeUI() {
  fetch(`https://${GetParentResourceName()}/closeUI`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: "{}"
  });
}

function notify(text) {
  const toast = document.getElementById("toast");
  toast.innerText = text;
  toast.style.display = "block";
  setTimeout(() => (toast.style.display = "none"), 3000);
}

function submitEvidence(event) {
  event.preventDefault();
  const data = {
    officer: getVal("officer"),
    callsign: getVal("callsign"),
    suspect: getVal("suspect"),
    dob: getVal("dob"),
    item: getVal("item"),
    amount: parseInt(getVal("amount")),
    evidence_id: getVal("evidence_id")
  };

  fetch(`https://${GetParentResourceName()}/submitEvidence`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data)
  }).then(() => {
    notify("✅ Evidence submitted.");
    fetch(`https://${GetParentResourceName()}/refresh`);
    document.querySelector("form").reset();
    switchTab("view");
  });
}

function buildEvidenceList(data, page = 1) {
  const list = document.getElementById("evidence-list");
  list.innerHTML = "";
  const perPage = 10;
  const start = (page - 1) * perPage;
  const visible = data.slice(start, start + perPage);

  visible.forEach(item => {
    const entry = document.createElement("div");
    const removed = item.removed_by ? ` ❌ Removed by ${item.removed_by}` : "";
    entry.setAttribute("data-id", item.evidence_id);
    entry.textContent = `${item.officer} [${item.callsign}] ➤ ${item.item} x${item.amount} | ID: ${item.evidence_id}${removed}`;
    entry.onclick = () => showEvidenceDetails(item);
    list.appendChild(entry);
  });

  document.getElementById("page-label").textContent = `Page ${currentPage}`;
}

function showEvidenceDetails(item) {
  selectedEvidence = item;
  document.getElementById("modal-details").innerHTML = `
    <b>Officer:</b> ${item.officer} [${item.callsign}]<br>
    <b>Suspect:</b> ${item.suspect} (DOB: ${item.dob})<br>
    <b>Item:</b> ${item.item} x${item.amount}<br>
    <b>Evidence ID:</b> ${item.evidence_id}<br>
    <b>Timestamp:</b> ${item.timestamp}<br>
    ${item.removed_by ? `<b>Removed By:</b> ${item.removed_by}` : ""}
  `;
  document.getElementById("delete-btn").style.display = item.removed_by ? "none" : "block";
  document.getElementById("modal").style.display = "flex";
}

function closeModal() {
  document.getElementById("modal").style.display = "none";
  selectedEvidence = null;
}

function deleteEvidence() {
  if (!selectedEvidence) return;
  fetch(`https://${GetParentResourceName()}/removeEvidence`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ id: selectedEvidence.id })
  }).then(() => {
    notify("🗑️ Evidence removed.");
    closeModal();
    fetch(`https://${GetParentResourceName()}/refresh`);
  });
}

function searchEvidence() {
  const filter = getVal("search").toLowerCase();
  const filtered = allEvidence.filter(e => e.evidence_id.toLowerCase().includes(filter));
  buildEvidenceList(filtered, 1);
}

function prevPage() {
  if (currentPage > 1) {
    currentPage--;
    buildEvidenceList(allEvidence, currentPage);
  }
}

function nextPage() {
  const totalPages = Math.ceil(allEvidence.length / 10);
  if (currentPage < totalPages) {
    currentPage++;
    buildEvidenceList(allEvidence, currentPage);
  }
}

function exportClipboard() {
  const rows = allEvidence.map(e =>
    `${e.timestamp} | ${e.officer} [${e.callsign}] | ${e.item} x${e.amount} | ID: ${e.evidence_id}`
  ).join("\n");
  navigator.clipboard.writeText(rows).then(() => notify("📋 Copied to clipboard"));
}

function getVal(id) {
  return document.getElementById(id).value;
}

function showDepartments(departments) {
  const container = document.getElementById("departments");
  container.innerHTML = "";
  departments.forEach(dep => {
    const btn = document.createElement("button");
    btn.textContent = dep.name;
    btn.onclick = () => {
      document.getElementById("department-select").style.display = "none";
      document.getElementById("locker-ui").style.display = "block";
      buildEvidenceList(dep.evidence || []);
    };
    container.appendChild(btn);
  });
}

window.addEventListener("message", (event) => {
  const data = event.data;
  if (data.type === "openUI") {
    if (data.departments) {
      showDepartments(data.departments);
    } else {
      allEvidence = data.evidence || [];
      currentPage = 1;
      buildEvidenceList(allEvidence, currentPage);
      document.getElementById("department-select").style.display = "none";
      document.getElementById("locker-ui").style.display = "block";
    }
  }
});

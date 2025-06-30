CREATE TABLE IF NOT EXISTS evidence_storage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    officer VARCHAR(100),
    callsign VARCHAR(20),
    suspect VARCHAR(100),
    dob VARCHAR(20),
    item VARCHAR(100),
    amount INT,
    evidence_id VARCHAR(50),
    timestamp DATETIME,
    department VARCHAR(50),
    removed_by VARCHAR(100),
    removed_at DATETIME
);

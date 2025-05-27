import React, { useEffect, useState } from 'react';
import axios from 'axios';

const apiBase = "http://localhost:8000/api";

const App = () => {
  const [rmfStatus, setRmfStatus] = useState<any>({});
  const [risks, setRisks] = useState<any[]>([]);

  useEffect(() => {
    Promise.all([
      axios.get(`${apiBase}/rmf/govern`),
      axios.get(`${apiBase}/rmf/map`),
      axios.get(`${apiBase}/rmf/measure`),
      axios.get(`${apiBase}/rmf/manage`),
      axios.get(`${apiBase}/risks/`)
    ]).then(([govern, map, measure, manage, riskData]) => {
      setRmfStatus({
        govern: govern.data.status,
        map: map.data.status,
        measure: measure.data.status,
        manage: manage.data.status,
      });
      setRisks(riskData.data);
    });
  }, []);

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial" }}>
      <h1>🧠 AI RMF Attestation Dashboard</h1>

      <h2>📊 RMF Status</h2>
      <ul>
        {Object.entries(rmfStatus).map(([key, value]) => (
          <li key={key}><strong>{key.toUpperCase()}</strong>: {value}</li>
        ))}
      </ul>

      <h2>⚠️ Risk Register</h2>
      {risks.length === 0 ? <p>No risks yet.</p> :
        <ul>
          {risks.map((risk, idx) => (
            <li key={idx}>
              <strong>{risk.name}</strong>: {risk.description} (Impact: {risk.impact}, Likelihood: {risk.likelihood})
            </li>
          ))}
        </ul>
      }
    </div>
  );
};

export default App;

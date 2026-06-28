import React, { useState, useEffect } from 'react';
import { Activity, Cpu, Coins, ShieldCheck, Server, Zap } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import './App.css';

// Simulated live stream data for the BME Deflationary Engine
const generateMockData = () => {
  const data = [];
  let currentSupply = 100000000;
  for (let i = 0; i < 20; i++) {
    const burned = Math.floor(Math.random() * 500) + 100;
    // BME Ratio: 95 minted for every 100 burned
    const minted = Math.floor(burned * 0.95);
    currentSupply = currentSupply - burned + minted;
    data.push({
      time: `-${20 - i}m`,
      burned,
      minted,
      supply: currentSupply
    });
  }
  return data;
};

const mockNodes = [
  { id: 'node-0x8792', region: 'us-central1-a', type: 'L4 Spot', status: 'Active', rep: 124, uptime: '99.9%' },
  { id: 'node-0x4a1b', region: 'us-east4-b', type: 'L4 Spot', status: 'Active', rep: 89, uptime: '99.7%' },
  { id: 'node-0x9f3e', region: 'us-east1-c', type: 'L4 Spot', status: 'Active', rep: 256, uptime: '100%' },
];

function App() {
  const [bmeData, setBmeData] = useState([]);
  
  useEffect(() => {
    setBmeData(generateMockData());
    
    // Simulate real-time updates every 3 seconds
    const interval = setInterval(() => {
      setBmeData(prev => {
        const newData = [...prev.slice(1)];
        const last = prev[prev.length - 1];
        const burned = Math.floor(Math.random() * 500) + 100;
        const minted = Math.floor(burned * 0.95);
        newData.push({
          time: 'Live',
          burned,
          minted,
          supply: last.supply - burned + minted
        });
        return newData;
      });
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="app-container">
      <header className="header">
        <h1>
          <Zap className="text-accent-blue" size={32} />
          Web3 AI Agent Economy
        </h1>
        <div className="status-badge animate-pulse">
          <div className="status-dot"></div>
          Arbitrum Testnet Connected
        </div>
      </header>

      {/* Top Metrics Grid */}
      <div className="grid-top">
        <div className="glass-panel">
          <div className="metric-title">
            <Activity size={18} className="text-accent-green" />
            Network TPS (Agents)
          </div>
          <div className="metric-value">
            2,451 <span className="metric-unit">tx/s</span>
          </div>
        </div>

        <div className="glass-panel">
          <div className="metric-title">
            <Cpu size={18} className="text-accent-blue" />
            Active GCP Nodes
          </div>
          <div className="metric-value">
            14 <span className="metric-unit">L4 GPUs</span>
          </div>
        </div>

        <div className="glass-panel">
          <div className="metric-title">
            <Coins size={18} className="text-accent-green" />
            Deflationary Burn Rate
          </div>
          <div className="metric-value">
            4.8 <span className="metric-unit">WAIB/sec</span>
          </div>
        </div>
      </div>

      {/* Main Content Grid */}
      <div className="grid-main">
        
        {/* Left Column: BME Tokenomics */}
        <div className="glass-panel flex-col">
          <div className="flex justify-between items-center mb-4">
            <h2 className="metric-title" style={{ fontSize: '1rem', color: '#f8fafc', marginBottom: 0 }}>
              Burn-and-Mint Equilibrium (BME) Live Stream
            </h2>
          </div>
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.875rem' }}>
            For every 100 WAIB tokens burned for inference, exactly 95 are algorithmically minted.
          </p>
          
          <div className="chart-container">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={bmeData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id="colorBurn" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--color-arb-blue)" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="var(--color-arb-blue)" stopOpacity={0}/>
                  </linearGradient>
                  <linearGradient id="colorMint" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--color-sol-green)" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="var(--color-sol-green)" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <XAxis dataKey="time" stroke="var(--color-border)" tick={{ fill: 'var(--color-text-muted)', fontSize: 12 }} />
                <YAxis stroke="var(--color-border)" tick={{ fill: 'var(--color-text-muted)', fontSize: 12 }} />
                <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" vertical={false} />
                <Tooltip 
                  contentStyle={{ backgroundColor: 'var(--bg-obsidian)', border: '1px solid var(--color-border)', borderRadius: '8px' }}
                  itemStyle={{ color: '#fff' }}
                />
                <Area type="monotone" dataKey="burned" name="Tokens Burned" stroke="var(--color-arb-blue)" fillOpacity={1} fill="url(#colorBurn)" />
                <Area type="monotone" dataKey="minted" name="Tokens Minted" stroke="var(--color-sol-green)" fillOpacity={1} fill="url(#colorMint)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>

        {/* Right Column: Node Fleet Status */}
        <div className="glass-panel">
          <div className="flex justify-between items-center mb-4">
            <h2 className="metric-title" style={{ fontSize: '1rem', color: '#f8fafc', marginBottom: 0 }}>
              <Server size={18} className="text-accent-blue" />
              GCP Node Fleet
            </h2>
          </div>
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.875rem', marginBottom: '1rem' }}>
            Live reputation scores synced from ERC-8004 Registry.
          </p>

          <table className="node-table">
            <thead>
              <tr>
                <th>Node ID</th>
                <th>Region</th>
                <th>Reputation</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {mockNodes.map((node) => (
                <tr key={node.id}>
                  <td style={{ fontFamily: 'monospace' }}>{node.id}</td>
                  <td>{node.region}</td>
                  <td><span className="reputation-score">+{node.rep}</span></td>
                  <td style={{ color: 'var(--color-sol-green)' }}>{node.status}</td>
                </tr>
              ))}
            </tbody>
          </table>
          
          <div style={{ marginTop: '2rem', padding: '1rem', background: 'rgba(255,255,255,0.02)', borderRadius: '8px', border: '1px solid var(--color-border)' }}>
             <h3 style={{ fontSize: '0.875rem', color: 'var(--color-text-muted)', marginBottom: '0.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
               <ShieldCheck size={16} className="text-accent-green" /> Security Audit
             </h3>
             <p style={{ fontSize: '0.875rem', color: 'var(--color-text-main)' }}>
               All active nodes have passed CP-SNARK verification for their last 100 inference requests.
             </p>
          </div>
        </div>

      </div>
    </div>
  );
}

export default App;

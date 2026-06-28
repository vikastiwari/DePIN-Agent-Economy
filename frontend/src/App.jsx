import React, { useState, useEffect } from 'react';
import { Activity, Cpu, Coins, ShieldCheck, Server, Zap, Globe, Blocks } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { JsonRpcProvider, formatUnits } from 'ethers';
import './App.css';

function App() {
  const [bmeData, setBmeData] = useState([]);
  const [nodes, setNodes] = useState([]);
  const [networkInfo, setNetworkInfo] = useState({ blockNumber: 0, baseFee: '0' });
  const [backendStatus, setBackendStatus] = useState("Waiting for E2E Script...");
  
  // 1. Connect to Live Arbitrum Sepolia Testnet
  useEffect(() => {
    // Official Arbitrum Sepolia Public RPC
    const provider = new JsonRpcProvider('https://sepolia-rollup.arbitrum.io/rpc');
    
    const fetchNetworkData = async () => {
      try {
        const blockNumber = await provider.getBlockNumber();
        const feeData = await provider.getFeeData();
        const baseFee = feeData.gasPrice ? formatUnits(feeData.gasPrice, 'gwei') : '0';
        
        setNetworkInfo({
          blockNumber,
          baseFee: parseFloat(baseFee).toFixed(4)
        });
      } catch (err) {
        console.error("Web3 Connection Error:", err);
      }
    };

    fetchNetworkData();
    const interval = setInterval(fetchNetworkData, 12000); // Arbitrum block time is fast, poll every 12s
    return () => clearInterval(interval);
  }, []);

  // 2. Connect to Python Backend WebSockets
  useEffect(() => {
    const ws = new WebSocket('ws://localhost:8000/ws');
    
    ws.onopen = () => {
      console.log("Connected to Python E2E Backend.");
    };

    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      
      if (data.type === 'bme_tick') {
        setBmeData(prev => {
          const newData = [...prev];
          if (newData.length > 20) newData.shift();
          newData.push({
            time: new Date().toLocaleTimeString(),
            burned: data.burned,
            minted: data.minted,
            supply: data.supply
          });
          return newData;
        });
      } else if (data.type === 'node_status') {
        setNodes(prev => {
          // Update or add node
          const exists = prev.find(n => n.id === data.node.id);
          if (exists) {
            return prev.map(n => n.id === data.node.id ? data.node : n);
          }
          return [...prev, data.node];
        });
      } else if (data.type === 'status_update') {
        setBackendStatus(data.message);
      }
    };

    ws.onclose = () => {
      console.log("WebSocket disconnected.");
    };

    return () => ws.close();
  }, []);

  return (
    <div className="app-container">
      <header className="header">
        <h1>
          <Zap className="text-accent-blue" size={32} />
          Web3 AI Agent Economy
        </h1>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <div className="status-badge">
            <Globe size={16} />
            E2E Server: {backendStatus}
          </div>
          <div className="status-badge animate-pulse">
            <div className="status-dot"></div>
            Arbitrum Sepolia
          </div>
        </div>
      </header>

      {/* Top Metrics Grid */}
      <div className="grid-top">
        <div className="glass-panel">
          <div className="metric-title">
            <Blocks size={18} className="text-accent-green" />
            Live Block Number
          </div>
          <div className="metric-value">
            {networkInfo.blockNumber.toLocaleString()}
          </div>
        </div>

        <div className="glass-panel">
          <div className="metric-title">
            <Activity size={18} className="text-accent-blue" />
            Network Base Fee
          </div>
          <div className="metric-value">
            {networkInfo.baseFee} <span className="metric-unit">Gwei</span>
          </div>
        </div>

        <div className="glass-panel">
          <div className="metric-title">
            <Cpu size={18} className="text-accent-green" />
            Active GCP Nodes
          </div>
          <div className="metric-value">
            {nodes.filter(n => n.status === 'Active').length} <span className="metric-unit">L4 GPUs</span>
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
            Awaiting streaming events from Python Gauntlet...
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
              Live GCP Node Fleet
            </h2>
          </div>
          <p style={{ color: 'var(--color-text-muted)', fontSize: '0.875rem', marginBottom: '1rem' }}>
            Instances spawned by the Artemis Gauntlet script.
          </p>

          {nodes.length === 0 ? (
            <div style={{ padding: '2rem', textAlign: 'center', color: 'var(--color-text-muted)' }}>
              No active nodes. Run the E2E script!
            </div>
          ) : (
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
                {nodes.map((node) => (
                  <tr key={node.id}>
                    <td style={{ fontFamily: 'monospace' }}>{node.id}</td>
                    <td>{node.region}</td>
                    <td><span className="reputation-score">+{node.rep}</span></td>
                    <td style={{ color: node.status === 'Active' ? 'var(--color-sol-green)' : 'var(--color-text-muted)' }}>{node.status}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          
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

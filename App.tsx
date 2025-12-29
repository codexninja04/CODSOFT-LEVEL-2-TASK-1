import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Jobs from './pages/Jobs';
import JobDetails from './pages/JobDetails';
import Login from './pages/Login';
import Signup from './pages/Signup';
import Contact from './pages/Contact';
import EmployerDashboard from './pages/EmployerDashboard';
import CandidateDashboard from './pages/CandidateDashboard';
import PostJob from './pages/PostJob';

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <div className="min-h-screen bg-gray-50">
          <Navbar />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/jobs" element={<Jobs />} />
            <Route path="/jobs/:id" element={<JobDetails />} />
            <Route path="/login" element={<Login />} />
            <Route path="/signup" element={<Signup />} />
            <Route path="/contact" element={<Contact />} />
            <Route path="/employer/dashboard" element={<EmployerDashboard />} />
            <Route path="/employer/post-job" element={<PostJob />} />
            <Route path="/candidate/dashboard" element={<CandidateDashboard />} />
          </Routes>
        </div>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;

import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import mongoose from 'mongoose';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB error:', err));

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/api/auth', (await import('./routes/auth.js')).default);
app.use('/api/services', (await import('./routes/services.js')).default);
app.use('/api/products', (await import('./routes/products.js')).default);
app.use('/api/subscriptions', (await import('./routes/subscriptions.js')).default);
app.use('/api/dashboard', (await import('./routes/dashboard.js')).default);
app.use('/api/payments', (await import('./routes/payments.js')).default);
app.use('/api/ai', (await import('./routes/ai.js')).default);
app.use('/api/admin', (await import('./routes/admin.js')).default);
app.use('/api/coupons', (await import('./routes/coupons.js')).default);
app.use('/api/loyalty', (await import('./routes/loyalty.js')).default);
app.use('/api/referral', (await import('./routes/referral.js')).default);
app.use('/api/reviews', (await import('./routes/reviews.js')).default);
app.use('/api/wishlist', (await import('./routes/wishlist.js')).default);
app.use('/api/notifications', (await import('./routes/notifications.js')).default);
app.use('/api/blogs', (await import('./routes/blogs.js')).default);

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({ message: err.message || 'Internal server error' });
});

app.listen(PORT, () => {
  console.log(`Calcutta Node API running on port ${PORT}`);
});

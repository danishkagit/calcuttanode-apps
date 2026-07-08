import mongoose from 'mongoose';

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  slug: { type: String, unique: true },
  description: String,
  price: Number,
  category: String,
  fileUrl: String,
  features: [String],
  active: { type: Boolean, default: true },
}, { timestamps: true });

export default mongoose.model('Product', productSchema);

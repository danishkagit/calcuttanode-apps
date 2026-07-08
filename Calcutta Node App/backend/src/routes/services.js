import { Router } from 'express';
import Service from '../models/Service.js';

const router = Router();

router.get('/', async (req, res) => {
  try {
    const filter = req.query.category ? { category: req.query.category, active: true } : { active: true };
    const services = await Service.find(filter).sort({ trending: -1 });
    res.json(services);
  } catch (e) { res.status(500).json({ message: e.message }); }
});

router.get('/:id', async (req, res) => {
  try {
    const service = await Service.findById(req.params.id);
    if (!service) return res.status(404).json({ message: 'Service not found' });
    res.json(service);
  } catch (e) { res.status(500).json({ message: e.message }); }
});

export default router;

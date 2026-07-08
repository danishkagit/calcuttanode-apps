import { Router } from 'express';
const router = Router();
router.get('/', (req, res) => res.json([]));
router.get('/search', (req, res) => res.json([]));
export default router;

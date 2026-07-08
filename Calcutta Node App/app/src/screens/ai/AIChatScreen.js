import React, { useState, useRef, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, StyleSheet, KeyboardAvoidingView, Platform } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import api from '../../api/client';
import { colors } from '../../constants/colors';
import { API_BASE_URL } from '../../constants/config';

const defaultModels = [
  { id: 'deepseek-v4-flash-free', name: 'DeepSeek V4 Flash', icon: '🔍' },
  { id: 'mimo-v2.5-free', name: 'MiMo V2.5', icon: '🧠' },
  { id: 'north-mini-code-free', name: 'North Mini Code', icon: '⚡' },
  { id: 'nemotron-3-ultra-free', name: 'Nemotron 3 Ultra', icon: '🚀' },
  { id: 'hy3-free', name: 'Hy3', icon: '🌊' },
  { id: 'big-pickle', name: 'Big Pickle', icon: '🥒' },
  { id: 'antigravity-gemini-3.1-pro', name: 'Gemini 3.1 Pro', icon: '🌟' },
  { id: 'antigravity-gemini-3-flash', name: 'Gemini 3 Flash', icon: '⚡' },
  { id: 'gemini-2.5-flash', name: 'Gemini 2.5 Flash', icon: '💎' },
  { id: 'antigravity-claude-sonnet-4-6', name: 'Claude Sonnet 4.6', icon: '🎯' },
  { id: 'antigravity-claude-opus-4-6-thinking', name: 'Claude Opus 4.6', icon: '🧠' },
];

const suggestions = ['What services do you offer?', 'How can I fix a slow computer?', 'Tell me about your hosting plans'];

export default function AIChatScreen() {
  const [models, setModels] = useState(defaultModels);
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [selectedModel, setSelectedModel] = useState(models[0]?.id || defaultModels[0].id);
  const scrollRef = useRef();

  useEffect(() => {
    fetch(`${API_BASE_URL}/ai/models`)
      .then(res => res.json())
      .then(data => { if (Array.isArray(data) && data.length) { setModels(data); setSelectedModel(data[0].id); } })
      .catch(() => {});
  }, []);

  async function sendMessage(text) {
    const userMsg = { role: 'user', content: text };
    setMessages(prev => [...prev, userMsg]);
    setInput('');
    setLoading(true);
    try {
      const { data } = await api.post('/ai/chat', { message: text, model: selectedModel });
      setMessages(prev => [...prev, { role: 'assistant', content: data.reply || data.message || 'No response' }]);
    } catch {
      setMessages(prev => [...prev, { role: 'assistant', content: 'Sorry, I encountered an error. Please try again.' }]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : undefined} keyboardVerticalOffset={90}>
      <LinearGradient colors={['rgba(139,92,246,0.04)', 'transparent']} style={styles.grad} />
      <View style={styles.header}>
        <Text style={styles.title}>AI Chat</Text>
        <Text style={styles.subtitle}>{models.length} free models — auto-fallback</Text>
      </View>
      <ScrollView horizontal style={styles.modelRow} showsHorizontalScrollIndicator={false}>
        {models.map((m) => (
          <TouchableOpacity key={m.id} style={[styles.modelChip, selectedModel === m.id && styles.modelChipActive]} onPress={() => setSelectedModel(m.id)}>
            <Text style={styles.modelIcon}>{m.icon}</Text>
            <Text style={[styles.modelName, selectedModel === m.id && styles.modelNameActive]}>{m.name}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
      <ScrollView style={styles.chatArea} ref={scrollRef} onContentSizeChange={() => scrollRef.current?.scrollToEnd({ animated: true })}>
        {messages.length === 0 && (
          <View style={styles.welcome}>
            <Text style={styles.welcomeIcon}>🤖</Text>
            <Text style={styles.welcomeTitle}>How can I help you?</Text>
            <Text style={styles.welcomeSub}>Ask me about services, pricing, or tech support</Text>
            <View style={styles.suggestions}>
              {suggestions.map((s, i) => (
                <TouchableOpacity key={i} style={styles.suggestionChip} onPress={() => sendMessage(s)}>
                  <Text style={styles.suggestionText}>{s}</Text>
                </TouchableOpacity>
              ))}
            </View>
          </View>
        )}
        {messages.map((msg, i) => (
          <View key={i} style={[styles.bubble, msg.role === 'user' ? styles.userBubble : styles.aiBubble]}>
            <Text style={[styles.bubbleText, msg.role === 'user' && styles.userBubbleText]}>{msg.content}</Text>
          </View>
        ))}
        {loading && (
          <View style={[styles.bubble, styles.aiBubble]}>
            <Text style={styles.thinking}>Thinking...</Text>
          </View>
        )}
      </ScrollView>
      <View style={styles.inputRow}>
        <TextInput style={styles.input} placeholder="Ask anything..." placeholderTextColor={colors.textMuted} value={input} onChangeText={setInput} multiline maxLength={500} />
        <TouchableOpacity style={[styles.sendButton, !input.trim() && { opacity: 0.4 }]} onPress={() => sendMessage(input.trim())} disabled={!input.trim() || loading}>
          <Text style={styles.sendIcon}>➤</Text>
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  grad: { position: 'absolute', top: 0, left: 0, right: 0, height: 150 },
  header: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 8 },
  title: { fontSize: 26, fontWeight: '800', color: colors.textPrimary },
  subtitle: { fontSize: 12, color: colors.textMuted, marginTop: 2 },
  modelRow: { paddingHorizontal: 16, marginBottom: 12 },
  modelChip: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 14, paddingVertical: 8, borderRadius: 20, backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, marginRight: 8 },
  modelChipActive: { borderColor: colors.neonCyan, backgroundColor: colors.neonCyan + '15' },
  modelIcon: { fontSize: 14, marginRight: 6 },
  modelName: { fontSize: 13, color: colors.textMuted, fontWeight: '500' },
  modelNameActive: { color: colors.neonCyan, fontWeight: '600' },
  chatArea: { flex: 1, paddingHorizontal: 16 },
  welcome: { alignItems: 'center', paddingTop: 40 },
  welcomeIcon: { fontSize: 48, marginBottom: 12 },
  welcomeTitle: { fontSize: 20, fontWeight: '700', color: colors.textPrimary },
  welcomeSub: { fontSize: 13, color: colors.textMuted, marginTop: 4, marginBottom: 20 },
  suggestions: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'center', gap: 8 },
  suggestionChip: { paddingHorizontal: 16, paddingVertical: 10, borderRadius: 12, backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border },
  suggestionText: { fontSize: 13, color: colors.textSecondary },
  bubble: { maxWidth: '80%', padding: 14, borderRadius: 18, marginBottom: 10 },
  userBubble: { backgroundColor: colors.neonCyan, alignSelf: 'flex-end', borderBottomRightRadius: 4 },
  aiBubble: { backgroundColor: colors.surfaceLight, alignSelf: 'flex-start', borderBottomLeftRadius: 4, borderWidth: 1, borderColor: colors.border },
  bubbleText: { fontSize: 14, color: colors.textPrimary, lineHeight: 20 },
  userBubbleText: { color: colors.black },
  thinking: { fontSize: 14, color: colors.textMuted, fontStyle: 'italic' },
  inputRow: { flexDirection: 'row', alignItems: 'flex-end', paddingHorizontal: 12, paddingVertical: 10, borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.surface },
  input: { flex: 1, backgroundColor: colors.surfaceLight, borderRadius: 20, paddingHorizontal: 16, paddingVertical: 10, fontSize: 14, color: colors.textPrimary, maxHeight: 100, marginRight: 8 },
  sendButton: { width: 44, height: 44, borderRadius: 22, backgroundColor: colors.neonCyan, justifyContent: 'center', alignItems: 'center' },
  sendIcon: { fontSize: 18, color: colors.black },
});

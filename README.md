# Chat Auto-Scroll Challenge

## Setup

1. Get a free Gemini API key from [ai.google.dev](https://ai.google.dev)
2. Run `flutter pub get`
3. Run `flutter run` (web, macOS, or any platform)
4. Enter your API key and start chatting

## Demo video 



https://github.com/user-attachments/assets/5a00dc5c-d4b6-4e99-8164-73af83554ed1



## The Problem

This app uses [flutter_chat_ui](https://github.com/flyerhq/flutter_chat_ui) to display a streaming chat with Google Gemini. When you send a message, the AI response streams in token by token.

**Try it:** Send multiple messages (e.g. _"Write a detailed essay about the history of the internet"_) and notice the scroll UX issues as the responses stream in.

**Test it thoroughly before you start coding.** Pay attention to every detail of how auto-scroll engages, disengages, and resumes. Your solution will be scored primarily on how closely it matches this behavior.

You are free to use any AI tools you'd like. What matters is the end result.

## Solution: Smart Auto-Scroll Implementation

I have implemented a robust `ChatAutoScroller` that manages the chat's scroll state intelligently, matching the behavior of the reference implementation.

## UX Issues Identified and Fixed

- **Streaming Auto-Scroll**: New AI tokens were appearing off-screen. Fixed by implementing a frame-sync scroller that follows the bottom.
- **Manual Scroll Awareness (Pause)**: Auto-scroll used to "yank" the user down while they were trying to read history. Fixed with a threshold-based pause.
- **Auto-Resume**: Returning to the bottom now automatically re-activates the follow-along behavior for active streams.
- **Respectful Send Behavior**: Sending a message while scrolled up now keeps your current view, only auto-scrolling if you are already at the bottom.
- **Stop Button Availability**: The stop button was previously tied to ephemeral state; now uses a provider-backed scroller state for better reliability.

## Deployed URL
[https://hazzemSaid.github.io/chat-scroll-challenge/](https://hazzemSaid.github.io/chat-scroll-challenge/)

## Evaluation
- [x] Auto-scroll during streaming
- [x] Manual scroll-away pause
- [x] Returning to bottom resumes auto-scroll
- [x] UI stays put when sending while scrolled away
- [x] Modular, provider-integrated implementation

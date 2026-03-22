/// Application-wide constants
class AppConstants {
  AppConstants._();

  static const String appName = 'Tetris Multiplayer';
  static const String appVersion = '1.0.0';

  // Firestore collection names
  static const String usersCollection = 'users';
  static const String clansCollection = 'clans';
  static const String chatsCollection = 'chats';
  static const String matchesCollection = 'matches';

  // Realtime DB paths
  static const String matchesPath = 'matches';
  static const String onlineStatusPath = 'onlineStatus';
  static const String chatPath = 'chats';

  // Game constants
  static const int boardWidth = 10;
  static const int boardHeight = 20;
  static const int targetFps = 60;

  // Tetromino types
  static const List<String> tetrominoTypes = ['I', 'O', 'T', 'S', 'Z', 'J', 'L'];

  // Scoring (standard Tetris guideline)
  static const Map<int, int> lineScores = {
    1: 100,
    2: 300,
    3: 500,
    4: 800, // Tetris
  };

  // Penalty lines per cleared lines
  static const Map<int, int> penaltyLines = {
    2: 1,
    3: 2,
    4: 4,
  };

  // Level speed in milliseconds per drop
  static const List<int> levelSpeeds = [
    800, 720, 630, 550, 470, 380, 300, 220, 130, 100, // Levels 1-10
    80, 80, 80, 70, 70, 70, 50, 50, 50, 30,           // Levels 11-20
    30, 30, 30, 30, 30, 30, 30, 30, 20, 20,           // Levels 21-30
  ];

  // XP thresholds per level
  static const int xpPerLevel = 1000;
  static const int xpPerWin = 50;
  static const int xpPerLoss = 10;
  static const int xpPerGame = 20;

  // Clan XP
  static const int clanXpPerGame = 5;
  static const int clanXpPerWin = 10;
  static const int clanXpPerWarWin = 50;
  static const int clanMaxMembers = 50;

  // Friend invite timeout in seconds
  static const int inviteTimeoutSeconds = 30;

  // Matchmaking timeout
  static const int matchmakingTimeoutSeconds = 60;
}

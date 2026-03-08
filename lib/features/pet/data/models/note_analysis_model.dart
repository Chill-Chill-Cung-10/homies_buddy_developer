import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/user_tone.dart';

part 'note_analysis_model.freezed.dart';
part 'note_analysis_model.g.dart';

/// Note Analysis Model - Kết quả AI (LLM) phân tích tone cảm xúc
///
/// Quan hệ **1:1** với `MOMENT_NOTE`. Lưu tất cả metadata
/// từ LLM analysis để feed vào Pet Behavior Engine
@freezed
abstract class NoteAnalysis with _$NoteAnalysis {
  const factory NoteAnalysis({
    required String id,

    /// Note ID — 1:1 với MOMENT_NOTE (unique)
    required String noteId,

    required String userId,

    /// Tone của note trước đó
    UserTone? lastUserTone,

    /// Tone dự đoán của note hiện tại
    required UserTone currentTonePredict,

    /// Tone có lặp lại so với note trước?
    required bool toneRepeat,

    /// Cường độ cảm xúc (1–5)
    required int level,

    required DateTime analyzedAt,

    /// Raw output của LLM (nullable, dùng để debug)
    String? rawLLMResponse,
  }) = _NoteAnalysis;

  factory NoteAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NoteAnalysisFromJson(json);
}

/// Extension để thêm các helper methods
extension NoteAnalysisX on NoteAnalysis {
  /// Kiểm tra xem tone có tươi vui không (veryHappy, happy)
  bool get isPositiveTone =>
      currentTonePredict == UserTone.veryHappy ||
      currentTonePredict == UserTone.happy;

  /// Kiểm tra xem tone có tiêu cực không (sad, verySad, anxious, angry)
  bool get isNegativeTone =>
      currentTonePredict == UserTone.sad ||
      currentTonePredict == UserTone.verySad ||
      currentTonePredict == UserTone.anxious ||
      currentTonePredict == UserTone.angry;

  /// Kiểm tra xem tone có trung tính không
  bool get isNeutralTone => currentTonePredict == UserTone.neutral;

  /// Tính emotional score để feed vào trend engine
  int get emotionalScore => currentTonePredict.emotionalScore;

  /// Kiểm tra xem tone có đang cải thiện không (so với note trước)
  bool get isToneImproving {
    if (lastUserTone == null) return false;
    return emotionalScore > lastUserTone!.emotionalScore;
  }

  /// Kiểm tra xem tone có đang xấu đi không
  bool get isToneDecreasing {
    if (lastUserTone == null) return false;
    return emotionalScore < lastUserTone!.emotionalScore;
  }

  /// Kiểm tra xem cảm xúc có rất cường độ không (level >= 4)
  bool get isHighIntensity => level >= 4;

  /// Kiểm tra xem cảm xúc có rất yếu không (level <= 1)
  bool get isLowIntensity => level <= 1;
}

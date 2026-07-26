import 'dart:convert';

/// Base class every data model extends — safe JSON parsing helpers that
/// fall back to a default instead of throwing on null/bad data.
abstract class Model {
  Map<String, dynamic> toJson();

  @override
  String toString() => jsonEncode(toJson());

  String stringFromJson(
    dynamic json,
    String attribute, {
    String defaultValue = '',
  }) {
    try {
      if (json == null || json[attribute] == null) return defaultValue;
      return json[attribute].toString();
    } catch (_) {
      return defaultValue;
    }
  }

  int intFromJson(dynamic json, String attribute, {int defaultValue = 0}) {
    try {
      if (json == null || json[attribute] == null) return defaultValue;
      // Via double, not int.tryParse — some fields come back as "20.0".
      return double.tryParse(json[attribute].toString())?.toInt() ??
          defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  double doubleFromJson(
    dynamic json,
    String attribute, {
    double defaultValue = 0.0,
  }) {
    try {
      if (json == null || json[attribute] == null) return defaultValue;
      return double.tryParse(json[attribute].toString()) ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  bool boolFromJson(
    dynamic json,
    String attribute, {
    bool defaultValue = false,
  }) {
    try {
      if (json == null || json[attribute] == null) return defaultValue;
      final value = json[attribute];
      if (value is bool) return value;
      // API sends some bools as 0/1 (e.g. is_day), not just true/false.
      return value.toString() == 'true' || value.toString() == '1';
    } catch (_) {
      return defaultValue;
    }
  }

  // Unused for now (no list fields in current.json) — kept for parity.
  List<T> listFromJson<T>(
    dynamic json,
    String attribute, {
    required T Function(dynamic e) callback,
  }) {
    try {
      if (json == null || json[attribute] == null || json[attribute] is! List) {
        return <T>[];
      }
      return (json[attribute] as List).map(callback).toList();
    } catch (_) {
      return <T>[];
    }
  }
}

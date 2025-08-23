import 'package:analytics/analytics.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_reporter.freezed.dart';

/// {@template analytics_reporter}
/// Interface for reporting analytics events.
///
/// This interface should be implemented to report [AnalyticsEvent]s to the
/// analytics service being used by the application.
///
/// See implementations of this interface:
/// - [FirebaseAnalyticsReporter]
/// {@endtemplate}
abstract interface class AnalyticsReporter {
  /// Logs the provided [event] to analytics.
  ///
  /// This method should be implemented to report the event to the analytics
  /// service being used by the application.
  ///
  /// The [event] should be logged to the analytics service as-is, including any
  /// parameters that are included with the event.
  Future<void> logEvent(AnalyticsEvent event);
}

/// {@template analytics_event}
/// Represents an event that can be logged to analytics by [AnalyticsReporter].
///
/// This class can be used to track user interactions, screen views, or other
/// significant actions within the application.
///
/// It is recommended to create custom events by extending this class, although
/// events can also be added directly using this class.
/// {@endtemplate}
@freezed
class AnalyticsEvent with _$AnalyticsEvent {
  /// {@macro analytics_event}
  const factory AnalyticsEvent({
    required String name,
    @Default({}) Set<AnalyticsParameter> parameters,
  }) = _AnalyticsEvent;
}

/// {@template analytics_parameter}
/// A parameter that can be added to an [AnalyticsEvent].
///
/// Currently, there are two types of parameters:
/// - [StringAnalyticsParameter]
/// - [NumberAnalyticsParameter]
///
/// Other types are not supported by Firebase Analytics. If you are using a
/// different tool for analytics, you can create a custom parameter type.
/// {@endtemplate}
@freezed
sealed class AnalyticsParameter with _$AnalyticsParameter {
  /// String analytics parameter.
  const factory AnalyticsParameter.string({
    required String name,
    required String value,
  }) = StringAnalyticsParameter;

  /// Number analytics parameter.
  const factory AnalyticsParameter.number({
    required String name,
    required num value,
  }) = NumberAnalyticsParameter;
}

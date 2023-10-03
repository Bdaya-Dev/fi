import 'package:fi_base/fi_base.dart';

// naming conventions are sorted by priority:
// 0. List/Group
// 1. String (for group only): TKey is String.
// 2. Dynamic: TItem and EItem is dynamic
// 3. Delegated: E is an aggregation of EItem

// ============= Start of `Group*` ===============

/// Represents a group of [FiState]s, where each of them has value of type
/// [TItem] and error of type [EItem].
///
/// Each [FiState] is given a key of type [TKey] to be able to
/// distinguish it.
typedef FiStateGroup<TKey, TItem, EItem, E>
    = FiState<Map<TKey, FiState<TItem, EItem>>, E>;

// ============= Start of `GroupString*` ===============
/// a version of [FiStateGroup] that has the following traits:
/// - String: means that `TKey` is of type `String`.
typedef FiStateGroupString<TItem, EItem, E>
    = FiState<Map<String, FiState<TItem, EItem>>, E>;

/// a version of [FiStateGroup] that has the following traits:
/// - String: means that `TKey` is of type `String`.
/// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`
typedef FiStateGroupStringDynamic<E>
    = FiState<Map<String, FiState<dynamic, dynamic>>, E>;

// /// a version of [FiStateGroup] that has the following traits:
// /// - String: means that `TKey` is of type `String`.
// /// - Delegated: means that `E` is of type `Map<TKey, EItem>`.
// typedef FiStateGroupStringDelegated<TItem, EItem>
//     = FiState<Map<String, FiState<TItem, EItem>>, Map<String, EItem>>;

// /// a version of [FiStateGroup] that has the following traits:
// /// - String: means that `TKey` is of type `String`.
// /// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`.
// /// - Delegated: means that `E` is of type `Map<TKey, EItem>`.
// typedef FiStateGroupStringDynamicDelegated
//     = FiState<Map<String, FiState<dynamic, dynamic>>, Map<String, dynamic>>;
// ============= End of `GroupString*` ===============

// ============= Start of `GroupDynamic*` ===============
/// a version of [FiStateGroup] that has the following traits:
/// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`.
typedef FiStateGroupDynamic<TKey, E>
    = FiState<Map<TKey, FiState<dynamic, dynamic>>, E>;

// /// a version of [FiStateGroup] that has the following traits:
// /// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`.
// /// - Delegated: means that `E` is of type `Map<TKey, EItem>`.
// typedef FiStateGroupDynamicDelegated<TKey>
//     = FiState<Map<TKey, FiState<dynamic, dynamic>>, Map<TKey, dynamic>>;
// ============= End of `GroupDynamic*` ===============

// ============= Start of `GroupDelegated*` ===============
// /// a version of [FiStateGroup] that has the following traits:
// /// - Delegated: means that `E` is of type `Map<TKey, EItem>`.
// typedef FiStateGroupDelegated<TKey, TItem, EItem>
//     = FiState<Map<TKey, FiState<TItem, EItem>>, Map<TKey, EItem>>;
// =================================================
// ============= End of `Group*` ===============

// ============= Start of `List*` ===============
/// Represents a list of [FiState]s that have value of type [TItem], and
/// error of type [EItem].
typedef FiStateList<TItem, EItem, E> = FiState<List<FiState<TItem, EItem>>, E>;

// ============= Start of `ListDynamic*` ===============

/// a version of [FiStateList] that has the following traits:
/// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`.
typedef FiStateListDynamic<E> = FiState<List<FiState<dynamic, dynamic>>, E>;

// /// a version of [FiStateList] that has the following traits:
// /// - Dynamic: means that `TItem` and `EItem` are of type `dynamic`.
// /// - Delegated: means that `E` is of type `List<EItem>`.
// typedef FiStateListDynamicDelegated
//     = FiState<List<FiState<dynamic, dynamic>>, List<dynamic>>;
// ============= End of `ListDynamic*` ===============
// ============= Start of `ListDelegated*` ===============
// /// a version of [FiStateList] that has the following traits:
// /// - Delegated: means that `E` is of type `List<EItem>`.
// typedef FiStateListDelegated<TItem, EItem>
//     = FiState<List<FiState<TItem, EItem>>, List<EItem>>;
// ============= End of `ListDelegated*` ===============
// ============= End of `List*` ===============

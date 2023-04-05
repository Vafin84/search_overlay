library search_overlay;

import 'package:flutter/material.dart';

class SearchOverlay<T> extends StatefulWidget {
  final InputDecoration? decoration;
  final TextEditingController searchController;
  final List<T> items;
  final Widget? noFind;
  final double? elevation;
  final double? width;
  final double? height;
  final double? offset;
  final double? borderRadius;
  final Widget Function(T item) displayItemFn;
  final String Function(T item) filterFn;
  const SearchOverlay({
    Key? key,
    this.decoration,
    required this.searchController,
    required this.items,
    required this.displayItemFn,
    required this.filterFn,
    this.noFind = const Text("Nothing found"),
    this.elevation,
    this.width,
    this.height = 200,
    this.offset,
    this.borderRadius,
  }) : super(key: key);

  @override
  State<SearchOverlay<T>> createState() => _SearchOverlayState<T>();
}

class _SearchOverlayState<T> extends State<SearchOverlay<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    widget.searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    widget.searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final renderObject = context.findRenderObject() as RenderBox;
    final Size size = renderObject.size;
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    if (widget.searchController.text.isNotEmpty) {
      _overlayEntry = OverlayEntry(builder: (context) {
        final items = widget.items
            .where((e) => widget
                .filterFn(e)
                .toLowerCase()
                .contains(widget.searchController.text.toLowerCase()))
            .toList();
        return Positioned(
          width: widget.width ?? size.width,
          height: widget.height,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0.0, (size.height + (widget.offset ?? 0.0))),
            child: Material(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: widget.elevation ?? 0.0,
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return widget.displayItemFn(items[index]);
                      },
                    )
                  : Center(child: widget.noFind),
            ),
          ),
        );
      });
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        key: widget.key,
        controller: widget.searchController,
        decoration: widget.decoration,
      ),
    );
  }
}

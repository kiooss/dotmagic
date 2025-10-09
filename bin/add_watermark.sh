#!/bin/bash

# =============================================================================
# 批量图片水印添加脚本
# 使用 ImageMagick 为指定目录的图片添加水印
# =============================================================================

# 默认配置
DEFAULT_WATERMARK_TEXT="© Your Company 2024"
DEFAULT_FONT_SIZE=60
DEFAULT_POSITION="southeast"
# DEFAULT_POSITION="northeast"
DEFAULT_OFFSET="+60+60"
# DEFAULT_FILL_COLOR="rgba(255,255,255,0.3)"
# DEFAULT_FILL_COLOR="rgba(170,170,170,0.9)"
DEFAULT_STROKE_COLOR="rgba(0,0,0,0.5)"
DEFAULT_STROKE_WIDTH=1
# DEFAULT_FONT="/System/Library/AssetsV2/com_apple_MobileAsset_Font7/8dc7805506cc9f233dcc19aabf593196842a47ae.asset/AssetData/Hannotate.ttc"
# DEFAULT_FONT="/System/Library/AssetsV2/com_apple_MobileAsset_Font7/8dc7805506cc9f233dcc19aabf593196842a47ae.asset/AssetData/Hannotate.ttc"
DEFAULT_FONT="/System/Library/AssetsV2/com_apple_MobileAsset_Font7/96af7ec9e88d5dae450d3162213f92a7b1129430.asset/AssetData/YuppySC-Regular.otf"

# 显示使用帮助
show_help() {
  echo "批量图片水印添加工具"
  echo ""
  echo "用法:"
  echo "  $0 [选项] <图片目录>"
  echo ""
  echo "选项:"
  echo "  -t, --text TEXT        水印文字 (默认: '$DEFAULT_WATERMARK_TEXT')"
  echo "  -s, --size SIZE        字体大小 (默认: $DEFAULT_FONT_SIZE)"
  echo "  -p, --position POS     水印位置 (默认: $DEFAULT_POSITION)"
  echo "                         可选: northwest, northeast, southwest, southeast, center"
  echo "  -o, --offset OFFSET    偏移量 (默认: '$DEFAULT_OFFSET')"
  echo "  -c, --color COLOR      文字颜色 (默认: '$DEFAULT_FILL_COLOR')"
  echo "  --stroke-color COLOR   描边颜色 (默认: '$DEFAULT_STROKE_COLOR')"
  echo "  --stroke-width WIDTH   描边宽度 (默认: $DEFAULT_STROKE_WIDTH)"
  echo "  -r, --recursive        递归处理子目录"
  echo "  --backup               处理前创建备份"
  echo "  --preview              预览模式，生成带'_preview'后缀的文件"
  echo "  -h, --help             显示此帮助信息"
  echo ""
  echo "示例:"
  echo "  $0 /path/to/images"
  echo "  $0 -t '© My Company' -s 40 ~/Pictures"
  echo "  $0 --recursive --backup ~/Photos"
  echo "  $0 --preview -t 'DRAFT' ./images"
  echo ""
  echo "支持的图片格式: jpg, jpeg, png, tiff, bmp, webp"
}

# 检查 ImageMagick 是否安装
check_imagemagick() {
  if ! command -v convert &>/dev/null; then
    echo "错误: 未找到 ImageMagick"
    echo "请先安装 ImageMagick:"
    echo "  brew install imagemagick"
    echo "或"
    echo "  sudo port install ImageMagick"
    exit 1
  fi
}

# 创建备份
create_backup() {
  local source_dir="$1"
  local backup_dir="${source_dir%/}_backup_$(date +%Y%m%d_%H%M%S)"

  echo "正在创建备份到: $backup_dir"
  if cp -r "$source_dir" "$backup_dir"; then
    echo "✓ 备份创建成功"
  else
    echo "✗ 备份创建失败"
    exit 1
  fi
}

# 处理单个图片文件
process_image() {
  local file="$1"
  local output_file="$2"
  local watermark_text="$3"
  local font_size="$4"
  local position="$5"
  local offset="$6"
  local fill_color="$7"
  local stroke_color="$8"
  local stroke_width="$9"

  # 检查文件是否存在且为图片格式
  if [[ ! -f "$file" ]]; then
    return 1
  fi

  # 验证是否为支持的图片格式
  local mime_type=$(file -b --mime-type "$file")
  if [[ ! "$mime_type" =~ ^image/ ]]; then
    echo "跳过非图片文件: $file"
    return 1
  fi

  echo "正在处理: $(basename "$file")"

  # 执行水印添加
  if
    # -font ~/Library/Fonts/NotoSerifSC-Regular.ttf \
    magick "$file" \
      -resize 1024x \
      -font "$DEFAULT_FONT" \
      -gravity "$position" \
      -pointsize "$font_size" \
      -fill "$fill_color" \
      -stroke "$stroke_color" \
      -strokewidth "$stroke_width" \
      -annotate "$offset" "$watermark_text" \
      "$output_file" # -weight "Bold" \
  then
    return 0
  else
    echo "✗ 处理失败: $file"
    return 1
  fi
}

# 批量处理图片
batch_process() {
  local target_dir="$1"
  local watermark_text="$2"
  local font_size="$3"
  local position="$4"
  local offset="$5"
  local fill_color="$6"
  local stroke_color="$7"
  local stroke_width="$8"
  local recursive="$9"
  local preview="${10}"

  local count=0
  local success_count=0
  local find_args=()

  # 设置查找参数
  if [[ "$recursive" == "true" ]]; then
    find_args+=(-type f)
  else
    find_args+=(-maxdepth 1 -type f)
  fi

  # 添加文件格式过滤
  find_args+=(\( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.tiff" -o -iname "*.bmp" -o -iname "*.webp" \))

  echo "开始批量处理..."
  echo "目录: $target_dir"
  echo "水印: $watermark_text"
  echo "递归: $recursive"
  echo "预览模式: $preview"
  echo "----------------------------------------"

  # 查找并处理文件
  while IFS= read -r -d '' file; do
    ((count++))

    # 确定输出文件路径
    local output_file="$file"
    if [[ "$preview" == "true" ]]; then
      local dir=$(dirname "$file")
      local filename=$(basename "$file")
      local name="${filename%.*}"
      local ext="${filename##*.}"
      output_file="$dir/${name}_preview.$ext"
    fi

    # 处理图片
    if process_image "$file" "$output_file" "$watermark_text" "$font_size" "$position" "$offset" "$fill_color" "$stroke_color" "$stroke_width"; then
      ((success_count++))
      echo "✓ 完成: $(basename "$file")"
    fi

  done < <(find "$target_dir" "${find_args[@]}" -print0)

  echo "----------------------------------------"
  echo "批量处理完成！"
  echo "总计文件: $count"
  echo "成功处理: $success_count"
  echo "失败处理: $((count - success_count))"
}

# 主函数
main() {
  # 默认参数
  local watermark_text="$DEFAULT_WATERMARK_TEXT"
  local font_size="$DEFAULT_FONT_SIZE"
  local position="$DEFAULT_POSITION"
  local offset="$DEFAULT_OFFSET"
  local fill_color="$DEFAULT_FILL_COLOR"
  local stroke_color="$DEFAULT_STROKE_COLOR"
  local stroke_width="$DEFAULT_STROKE_WIDTH"
  local recursive="false"
  local backup="false"
  local preview="false"
  local target_dir=""

  # 解析命令行参数
  while [[ $# -gt 0 ]]; do
    case $1 in
      -t | --text)
        watermark_text="$2"
        shift 2
        ;;
      -s | --size)
        font_size="$2"
        shift 2
        ;;
      -p | --position)
        position="$2"
        shift 2
        ;;
      -o | --offset)
        offset="$2"
        shift 2
        ;;
      -c | --color)
        fill_color="$2"
        shift 2
        ;;
      --stroke-color)
        stroke_color="$2"
        shift 2
        ;;
      --stroke-width)
        stroke_width="$2"
        shift 2
        ;;
      -r | --recursive)
        recursive="true"
        shift
        ;;
      --backup)
        backup="true"
        shift
        ;;
      --preview)
        preview="true"
        shift
        ;;
      -h | --help)
        show_help
        exit 0
        ;;
      -*)
        echo "未知选项: $1"
        echo "使用 -h 或 --help 查看帮助信息"
        exit 1
        ;;
      *)
        if [[ -z "$target_dir" ]]; then
          target_dir="$1"
        else
          echo "错误: 只能指定一个目录"
          exit 1
        fi
        shift
        ;;
    esac
  done

  # 检查必要参数
  if [[ -z "$target_dir" ]]; then
    echo "错误: 请指定图片目录"
    echo "使用 -h 或 --help 查看帮助信息"
    exit 1
  fi

  # 检查目录是否存在
  if [[ ! -d "$target_dir" ]]; then
    echo "错误: 目录不存在: $target_dir"
    exit 1
  fi

  # 检查 ImageMagick
  check_imagemagick

  # 创建备份（如果需要）
  if [[ "$backup" == "true" && "$preview" == "false" ]]; then
    create_backup "$target_dir"
  fi

  # 确认操作
  if [[ "$preview" == "false" ]]; then
    echo "警告: 此操作将直接修改原图片文件！"
    if [[ "$backup" == "false" ]]; then
      echo "建议使用 --backup 选项创建备份，或使用 --preview 预览效果"
    fi
    echo -n "确认继续？(y/N): "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "操作已取消"
      exit 0
    fi
  fi

  # 开始处理
  batch_process "$target_dir" "$watermark_text" "$font_size" "$position" "$offset" "$fill_color" "$stroke_color" "$stroke_width" "$recursive" "$preview"
}

# 执行主函数
main "$@"

for dir in lib/* ; do
    if [[ -d $dir ]]; then
        echo "[$dir]"
        cat $dir/solution.dart $dir/test.dart ./lib/mock_result.dart > "$dir/combined.dart"
        dart run "$dir/combined.dart"
    fi;
done;
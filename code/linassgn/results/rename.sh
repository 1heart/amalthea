mkdir _
for file in ./*
do
  if ! [[ ${file} = *.mat ]]
  then
    # echo "${file}"
    mv -i "${file}" "./${file//\./_}.mat"
  fi
done
mv _/* .
rm -rf _

# Zettelsky: Knowledge Management

Note Taking scripts based on the powerful Zettelkasten method, designed to enhance your research, study, and writing experience.

## Introduction

Zettelkasten, originally developed by Niklas Luhmann, is a proven knowledge management system that can greatly benefit your academic and creative pursuits. Our Note Taking Software aims to provide you with a digital Zettelkasten tool that simplifies knowledge organization, retrieval, and synthesis.

## Basic Usage

To create a new Zettel (note) and begin your knowledge management journey, follow these steps:

Run New Zettel Command:

```sh
make create
```

This command will prompt you to select a note type:

```sh
Enter the Zettelkasten note type (1 for fleeting, 2 for literature, 3 for permanent, 0 to exit):
```

After selecting a type, Zettelsky will create a new Zettel and add an entry to the index. It will then open the Zettel in text editor (default notepad), allowing you to start capturing your thoughts, insights, or research findings.

> Note: you can customize the default text editor by modifying the zettel_create.bat file, specifically, line 97.

## To resync indexs

If you need to resynchronize your Zettelkasten index for any reason, you can do so with the following command:

```sh
make sync
```

## Author

[Akash Meshram](https://akashmeshram.com/)

## License

This project is licensed under the **GPLv3**.
See [LICENSE](LICENSE) for more information.

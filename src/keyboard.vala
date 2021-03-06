/* keyboard.vala
 *
 * Copyright 2022 Vojtěch Perník
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class WG.Keyboard : Gtk.Box {
    public signal void insert (string cell);
    public signal void backspace ();
    public signal void enter ();
    public bool game_over = false;

    public Keyboard () {
        Object (
            orientation: Gtk.Orientation.VERTICAL,
            spacing: 4
        );

        halign = Gtk.Align.CENTER;
        hexpand = true;
        valign = Gtk.Align.CENTER;
        vexpand = true;
        margin_top = 6;
        margin_bottom = 6;
        margin_start = 6;
        margin_end = 6;

        foreach (string line in Data.get_keyboard ().split (";")) {
            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 4);
            append (box);
            box.halign = Gtk.Align.CENTER;
            box.hexpand = true;
            foreach (string key in line.split (",")) {
                string key_temp = key.strip ();
                key_temp = key_temp.replace ("{", "").replace ("}", "");

                Gtk.Button btn;

                if (key_temp == "enter") {
                    btn = new Gtk.Button.from_icon_name ("keyboard-enter-symbolic");
                    btn.clicked.connect (() => {
                        if (!game_over) enter ();
                    });
                } else if (key_temp == "backspace") {
                    btn = new Gtk.Button.from_icon_name ("entry-clear-symbolic");
                    btn.clicked.connect (() => {
                        if (!game_over) backspace ();
                    });
                } else {
                    string[] key_parts = key_temp.split ("/");
                    btn = new Gtk.Button.with_label (@"$(key_parts[0].strip ().up ())");
                    btn.clicked.connect (() => {
                        if (!game_over) insert (key_parts[1].strip ());
                    });
                }

                btn.can_focus = false;
                btn.add_css_class ("key");

                box.append (btn);
            }
        }
    }
}

/**
 * Singleton.h
 *
 * Copyright (C) 2017 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPL v2
 *
 * Inspired from http://stackoverflow.com/questions/1008019/c-singleton-design-pattern
 */


#ifndef __SINGLETON_H__
#define __SINGLETON_H__


template <class T> class Singleton
{
    public:
        static T& getInstance() {
            static T instance;  // Guaranteed to be destroyed.
                                // Instantiated on first use.
            return instance;
        }

    public:
        Singleton(Singleton const&)      = delete;
        void operator=(Singleton const&) = delete;

        // Note: Scott Meyers mentions in his Effective Modern
        //       C++ book, that deleted functions should generally
        //       be public as it results in better error messages
        //       due to the compilers behavior to check accessibility
        //       before deleted status

    protected:
        Singleton() {}        // Constructor? (the {} brackets) are needed here.
};


#endif
